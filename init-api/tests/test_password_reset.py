"""Isolated recovery rules: no network, email provider or real database."""
import unittest
from datetime import datetime, timedelta
from types import SimpleNamespace
from unittest.mock import MagicMock, patch

from app.core.exceptions import BaseError, ValidationError
from app.services import password_reset_service as recovery


class PasswordResetTests(unittest.TestCase):
    def setUp(self):
        self.repo = MagicMock()
        self.repo.allow.return_value = True
        self.repo.challenge.return_value = None
        self.user = SimpleNamespace(id=42, email="test@example.test",
                                    hashed_password="old-test-hash", session_version=2)
        self.repo.user_for_email.return_value = self.user
        self.repo.user_for_update.return_value = self.user
        for replacement in [
            patch.object(recovery, "PasswordResetRepository", return_value=self.repo),
            patch.object(recovery, "reset_email_service", SimpleNamespace(configured=True)),
            patch.object(recovery, "settings", SimpleNamespace(
                secret_key="isolated-test-key", password_reset_daily_limit=100)),
            patch.object(recovery, "get_password_hash", return_value="new-test-hash"),
        ]:
            replacement.start()
            self.addCleanup(replacement.stop)
        self.service = recovery.PasswordResetService(MagicMock())
        self.request = SimpleNamespace(email=self.user.email, language="ru")
        self.confirm = SimpleNamespace(email=self.user.email, code="123456",
                                       new_password="isolated-test-password")

    def challenge(self, **changes):
        key = recovery._email_key(self.user.email)
        challenge = SimpleNamespace(user_id=42, generation="test-generation",
            code_hash=recovery._code_hash(key, "test-generation", self.confirm.code),
            expires_at=datetime.utcnow() + timedelta(minutes=10), attempts=0,
            last_requested_at=datetime.utcnow() - timedelta(minutes=2))
        for name, value in changes.items():
            setattr(challenge, name, value)
        self.repo.challenge.return_value = challenge
        return challenge

    def test_request_stores_only_hash_and_returns_delivery_task(self):
        delivery = self.service.request_code(self.request, "test-client")
        key, generation, recipient, code, language = delivery
        stored = self.repo.db.add.call_args.args[0]
        self.assertEqual(recipient, self.user.email)
        self.assertEqual(language, "ru")
        self.assertRegex(code, r"^\d{6}$")
        self.assertNotEqual(stored.code_hash, code)
        self.assertEqual(stored.code_hash, recovery._code_hash(key, generation, code))
        self.repo.db.commit.assert_called_once()

    def test_unknown_email_never_schedules_mail(self):
        self.repo.user_for_email.return_value = None
        self.assertIsNone(self.service.request_code(self.request, "test-client"))
        stored = self.repo.db.add.call_args.args[0]
        self.assertIsNone(stored.user_id)
        self.assertIsNone(stored.code_hash)
        self.assertEqual(self.repo.allow.call_count, 2)

    def test_resend_cooldown_keeps_existing_code(self):
        challenge = self.challenge(last_requested_at=datetime.utcnow())
        original = challenge.code_hash
        self.assertIsNone(self.service.request_code(self.request, "test-client"))
        self.assertEqual(challenge.code_hash, original)
        self.repo.user_for_email.assert_not_called()

    def test_daily_quota_does_not_destroy_delivered_code(self):
        challenge = self.challenge()
        original = challenge.code_hash
        self.repo.allow.side_effect = [True, True, False]
        self.assertIsNone(self.service.request_code(self.request, "test-client"))
        self.assertEqual(challenge.code_hash, original)

    def test_database_failure_rolls_back_without_delivery(self):
        self.repo.allow.side_effect = RuntimeError("Simulated database outage")
        with self.assertRaises(RuntimeError):
            self.service.request_code(self.request, "test-client")
        self.repo.db.rollback.assert_called_once()
        self.repo.db.commit.assert_not_called()

    def test_missing_challenge_rejects_reset(self):
        with self.assertRaises(ValidationError):
            self.service.confirm(self.confirm, "test-client")
        self.repo.user_for_update.assert_not_called()

    def test_expired_challenge_rejects_reset(self):
        self.challenge(expires_at=datetime.utcnow() - timedelta(seconds=1))
        with self.assertRaises(ValidationError):
            self.service.confirm(self.confirm, "test-client")
        self.assertEqual(self.user.hashed_password, "old-test-hash")

    def test_fifth_wrong_attempt_invalidates_code(self):
        challenge = self.challenge(attempts=4)
        self.confirm.code = "000000"
        with self.assertRaises(ValidationError):
            self.service.confirm(self.confirm, "test-client")
        self.assertEqual(challenge.attempts, 5)
        self.assertIsNone(challenge.code_hash)
        self.assertEqual(self.user.session_version, 2)

    def test_correct_code_changes_hash_revokes_sessions_and_is_single_use(self):
        challenge = self.challenge()
        self.assertIsNone(self.service.confirm(self.confirm, "test-client"))
        self.assertEqual(self.user.hashed_password, "new-test-hash")
        self.assertEqual(self.user.session_version, 3)
        self.assertIsNone(challenge.code_hash)
        self.repo.db.commit.assert_called_once()
        with self.assertRaises(ValidationError):
            self.service.confirm(self.confirm, "test-client")
        self.assertEqual(self.user.session_version, 3)

    def test_changed_email_cannot_consume_another_identity_challenge(self):
        challenge = self.challenge()
        self.repo.user_for_update.return_value = SimpleNamespace(email="other@example.test")
        with self.assertRaises(ValidationError):
            self.service.confirm(self.confirm, "test-client")
        self.assertIsNone(challenge.code_hash)
        self.assertEqual(self.user.hashed_password, "old-test-hash")

    def test_confirm_rate_limit_rejects_without_password_change(self):
        self.repo.allow.return_value = False
        with self.assertRaises(BaseError):
            self.service.confirm(self.confirm, "test-client")
        self.repo.user_for_update.assert_not_called()


if __name__ == "__main__":
    unittest.main()
