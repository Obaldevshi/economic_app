"""Public reference FX, cached per worker; never used to rewrite user money."""
import asyncio
import time
from datetime import date, datetime, timezone
from decimal import Decimal
from xml.etree import ElementTree

import httpx
from app.repositories.exchange_rate_repository import ExchangeRateRepository

SUPPORTED_CURRENCIES = ("RUB", "USD", "EUR", "KZT", "BRL", "CNY", "INR", "SAR")
SOURCE = "https://www.cbr.ru/scripts/XML_daily.asp"


class ExchangeRateService:
    def __init__(self):
        self._lock = asyncio.Lock()
        self._snapshot = None
        self._next_attempt = 0.0
        self._failed = False

    async def get_rates(self, db):
        async with self._lock:
            repository = ExchangeRateRepository(db)
            if self._snapshot is None:
                last = repository.get_last()
                if last:
                    self._snapshot = {"as_of": last.as_of, "fetched_at": last.fetched_at,
                                      "source": SOURCE,
                                      "rub_per_unit": {code: Decimal(value) for code, value in last.rub_per_unit.items()}}
                db.commit()  # No database transaction held during the HTTP call.
            if time.monotonic() >= self._next_attempt:
                try:
                    async with httpx.AsyncClient(timeout=8, follow_redirects=False) as client:
                        response = await client.get(SOURCE)
                        response.raise_for_status()
                    if len(response.content) > 1_000_000 or b"<!DOCTYPE" in response.content.upper():
                        raise ValueError("Unexpected FX document")
                    root = ElementTree.fromstring(response.content)
                    effective_date = datetime.strptime(root.attrib["Date"], "%d.%m.%Y").date()
                    if self._snapshot and effective_date < self._snapshot["as_of"]:
                        raise ValueError("Older FX publication")
                    if effective_date > date.today():
                        # Publications may take effect after a weekend/holiday.
                        if (effective_date - date.today()).days > 14:
                            raise ValueError("Invalid FX date")
                    rates = {"RUB": Decimal(1)}
                    for node in root.findall("Valute"):
                        code = node.findtext("CharCode")
                        if code not in SUPPORTED_CURRENCIES:
                            continue
                        nominal = Decimal(node.findtext("Nominal"))
                        value = Decimal(node.findtext("Value").replace(",", "."))
                        if not nominal.is_finite() or not value.is_finite() or nominal <= 0 or value <= 0:
                            raise ValueError("Invalid FX value")
                        rates[code] = value / nominal
                    if not {"USD", "EUR", "KZT"}.issubset(rates):
                        raise ValueError("Incomplete FX document")
                    candidate = {
                        "as_of": effective_date, "fetched_at": datetime.now(timezone.utc),
                        "source": SOURCE, "rub_per_unit": rates,
                    }
                    repository.save(candidate)
                    self._snapshot = candidate
                    self._next_attempt = time.monotonic() + 3600
                    self._failed = False
                except (httpx.HTTPError, ValueError, KeyError, TypeError, ElementTree.ParseError, ArithmeticError):
                    self._next_attempt = time.monotonic() + 60
                    self._failed = True
                    return self._result(unavailable=True)
            return self._result(unavailable=self._failed)

    def _result(self, unavailable=False):
        if self._snapshot is None:
            return {"source": SOURCE, "rub_per_unit": {}, "is_stale": True}
        snapshot = dict(self._snapshot)
        snapshot["is_stale"] = unavailable or (date.today() - snapshot["as_of"]).days > 4
        return snapshot


exchange_rates = ExchangeRateService()
