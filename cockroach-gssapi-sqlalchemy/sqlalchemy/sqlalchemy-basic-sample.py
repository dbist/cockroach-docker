"""Build a Python App with CockroachDB and SQLAlchemy,
https://www.cockroachlabs.com/docs/stable/build-a-python-app-with-cockroachdb-sqlalchemy.html"""

# pylint: disable=E0401,C0330,C0103,R0903,C0103,W0612

import random
from math import floor
from sqlalchemy import create_engine, Column, Integer
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm.exc import NoResultFound, MultipleResultsFound
from cockroachdb.sqlalchemy import run_transaction

Base = declarative_base()


class Account(Base):
    """The Account class corresponds to the "accounts" database table."""
    __tablename__ = 'accounts'
    account_id = Column(Integer, primary_key=True)
    balance = Column(Integer)


# Create an engine to communicate with the database. The
# "cockroachdb://" prefix for the engine URL indicates that we are
# connecting to CockroachDB using the 'cockroachdb' dialect.
# For more information, see
# https://github.com/cockroachdb/sqlalchemy-cockroachdb.

SECURE_CLUSTER = True           # Set to False for insecure clusters
connect_args = {}

if SECURE_CLUSTER:
    connect_args = {
        'sslmode': 'verify-full',
        'sslrootcert': '/certs/ca.crt',
        'user': 'sqlalchemy',
        'krbsrvname': 'customspn'
        # 'sslkey': '/certs/client.root.key',
        # 'sslcert': '/certs/client.root.crt'
    }
else:
    connect_args = {'sslmode': 'disable'}

engine = create_engine(
    'cockroachdb://sqlalchemy@lb:26257/bank',
    connect_args=connect_args,
    echo=True                   # Log SQL queries to stdout
)

# Automatically create the "accounts" table based on the Account class.
Base.metadata.create_all(engine)


# Store the account IDs we create for later use.

seen_account_ids = set()


# The code below generates random IDs for new accounts.

def create_random_accounts(sess, num):
    """Create N new accounts with random IDs and random account balances.
    Note that since this is a demo, we don't do any work to ensure the
    new IDs don't collide with existing IDs.
    """
    new_accounts = []
    while num > 0:
        billion = 1000000000
        new_id = floor(random.random()*billion)
        seen_account_ids.add(new_id)
        new_accounts.append(
            Account(
                account_id=new_id,
                balance=floor(random.random()*1000000)
            )
        )
        num = num -1
    sess.add_all(new_accounts)


run_transaction(sessionmaker(bind=engine),
                lambda s: create_random_accounts(s, 100))


def get_random_account_id():
    """Helper for getting random existing account IDs."""
    account_id = random.choice(tuple(seen_account_ids))
    return account_id


def transfer_funds_randomly(session):
    """Transfer money randomly between accounts (during SESSION).

    Cuts a randomly selected account's balance in half, and gives the
    other half to some other randomly selected account.
    """
    source_id = get_random_account_id()
    sink_id = get_random_account_id()

    try:
        source = session.query(Account).filter_by(account_id=source_id).one()
    except NoResultFound:
        print('No result was found')
    except MultipleResultsFound:
        print('Multiple results were found')

    amount = floor(source.balance/2)

    # Check balance of the first account.
    if source.balance < amount:
        raise InsufficientFundsError("Insufficient funds")

    source.balance -= amount
    session.query(Account).filter_by(account_id=sink_id).update(
        {"balance": (Account.balance + amount)}
    )


# Run the transfer inside a transaction.

run_transaction(sessionmaker(bind=engine), transfer_funds_randomly)


class InsufficientFundsError(Exception):
    """Custom Error inherited from BaseException."""
