from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from .settings import settings


# Timeweb can close idle SSL connections. Validate a pooled connection before
# handing it to a request, instead of failing the first login after a pause.
engine = create_engine(
    settings.database_url,
    pool_pre_ping=True,
    pool_recycle=300,
    connect_args={"connect_timeout": 10},
    hide_parameters=True,
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
