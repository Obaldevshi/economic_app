from sqlalchemy.dialects.postgresql import insert
from app.models.exchange_rates import ExchangeRateCache


class ExchangeRateRepository:
    def __init__(self, db):
        self.db = db

    def get_last(self):
        return self.db.get(ExchangeRateCache, 1)

    def save(self, snapshot):
        values = {"id": 1, "as_of": snapshot["as_of"],
                  "fetched_at": snapshot["fetched_at"],
                  "rub_per_unit": {code: str(value) for code, value in snapshot["rub_per_unit"].items()}}
        stmt = insert(ExchangeRateCache).values(**values)
        self.db.execute(stmt.on_conflict_do_update(
            index_elements=[ExchangeRateCache.id], set_=values,
            where=ExchangeRateCache.as_of <= stmt.excluded.as_of,
        ))
        self.db.commit()
