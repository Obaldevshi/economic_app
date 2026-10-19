"""Sync orchestration/contract regression checks; not a DB concurrency test."""
import unittest
from datetime import datetime, timezone
from decimal import Decimal
from types import SimpleNamespace
from unittest.mock import MagicMock, patch
from uuid import uuid4

from app.core.exceptions import ConflictError, ValidationError
from app.schemas.savings_sync import SavingsSyncRequest
from app.services import savings_sync_service as sync


class SavingsSyncTests(unittest.TestCase):
    def setUp(self):
        self.repo = MagicMock()
        self.repo.find.return_value = None
        self.savings = MagicMock()
        self.savings.create_event.return_value = SimpleNamespace(id=123)
        self.savings.update_event.return_value = SimpleNamespace(id=123)
        self.inner = MagicMock()
        for replacement in [
            patch.object(sync, "SavingsSyncRepository", return_value=self.repo),
            patch.object(sync, "SavingsService", return_value=self.savings),
        ]:
            replacement.start()
            self.addCleanup(replacement.stop)
        self.sessions = patch.object(sync, "Session").start()
        self.addCleanup(patch.stopall)
        self.sessions.return_value.__enter__.return_value = self.inner
        self.service = sync.SavingsSyncService(MagicMock())

    def request(self, **changes):
        values = dict(operation_id=uuid4(), kind="create_event", payload={
            "impulse_name": "Test coffee", "amount": "300.00", "currency_code": "RUB",
            "is_invested": False, "occurred_at": "2026-10-18T12:00:00Z",
        })
        values.update(changes)
        return SavingsSyncRequest(**values)

    def test_create_stores_ack_after_mutation_and_scopes_it_to_owner(self):
        request = self.request()
        self.assertEqual(self.service.apply(42, request), {"entity_id": 123})
        self.repo.lock_account.assert_called_once_with(42)
        self.repo.find.assert_called_once_with(42, str(request.operation_id))
        self.savings._lock_balance.assert_called_once_with(42)
        self.savings.create_event.assert_called_once()
        self.assertEqual(self.savings.create_event.call_args.args[0], 42)
        ack = self.repo.db.add.call_args.args[0]
        self.assertEqual(ack.user_id, 42)
        self.assertEqual(ack.operation_id, str(request.operation_id))
        self.assertEqual(len(ack.request_hash), 64)
        self.repo.db.commit.assert_called_once()
        self.assertEqual(self.sessions.call_args.kwargs["join_transaction_mode"], "create_savepoint")

    def test_replay_returns_existing_ack_without_mutating_again(self):
        request = self.request()
        first = self.service.apply(42, request)
        self.repo.find.return_value = self.repo.db.add.call_args.args[0]
        self.assertEqual(self.service.apply(42, request), first)
        self.savings.create_event.assert_called_once()
        self.repo.db.add.assert_called_once()

    def test_reusing_operation_id_with_changed_payload_is_rejected(self):
        request = self.request()
        self.service.apply(42, request)
        self.repo.find.return_value = self.repo.db.add.call_args.args[0]
        changed = request.model_copy(update={"payload": {**request.payload, "amount": "900.00"}})
        with self.assertRaises(ConflictError):
            self.service.apply(42, changed)
        self.savings.create_event.assert_called_once()
        self.repo.db.rollback.assert_called_once()

    def test_reordered_json_keys_do_not_change_operation_fingerprint(self):
        request = self.request()
        first = self.service.apply(42, request)
        self.repo.find.return_value = self.repo.db.add.call_args.args[0]
        reordered = request.model_copy(update={"payload": dict(reversed(list(request.payload.items())))})
        self.assertEqual(self.service.apply(42, reordered), first)
        self.savings.create_event.assert_called_once()

    def test_failed_mutation_has_no_ack_and_rolls_back(self):
        self.savings.create_event.side_effect = RuntimeError("Synthetic mutation failure")
        with self.assertRaises(RuntimeError):
            self.service.apply(42, self.request())
        self.repo.db.add.assert_not_called()
        self.repo.db.commit.assert_not_called()
        self.repo.db.rollback.assert_called_once()

    def test_invalid_payload_does_not_call_mutation(self):
        with self.assertRaises(ValidationError):
            self.service.apply(42, self.request(payload={"amount": "not-money"}))
        self.savings.create_event.assert_not_called()
        self.repo.db.add.assert_not_called()

    def test_update_conflict_checks_owned_locked_record(self):
        record = SimpleNamespace(amount=Decimal("900.00"))
        self.savings.repository.get_event.return_value = record
        self.savings.repository.lock_record.return_value = record
        request = self.request(kind="update_event", entity_id=123,
                               before={"amount": "300.00"}, payload={"amount": "400.00"})
        with self.assertRaises(ConflictError):
            self.service.apply(42, request)
        self.savings.repository.get_event.assert_called_once_with(123, 42)
        self.savings.repository.lock_record.assert_called_once_with(record)
        self.savings.update_event.assert_not_called()

    def test_missing_update_identifier_is_rejected_before_lookup(self):
        with self.assertRaises(ValidationError):
            self.service.apply(42, self.request(kind="update_event", entity_id=None))
        self.savings.repository.get_event.assert_not_called()

    def test_numeric_and_utc_snapshot_comparisons_preserve_wire_contract(self):
        self.assertTrue(sync._equal(Decimal("300.00"), 300))
        self.assertTrue(sync._equal(datetime(2026, 10, 18, 12), "2026-10-18T15:00:00+03:00"))
        self.assertTrue(sync._equal(datetime(2026, 10, 18, 12, tzinfo=timezone.utc), "2026-10-18T12:00:00Z"))
        self.assertFalse(sync._equal(Decimal("300.00"), "invalid"))


if __name__ == "__main__":
    unittest.main()
