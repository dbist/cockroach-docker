\set aid random(1, 100000 * :scale)
\set delta random(0, 100 * :scale)
\set tid random(0, 10 * :scale)
\set bid random(0, 100 * :scale)

-- https://www.postgresql.org/docs/13/pgbench.html
-- What Is the “Transaction” Actually Performed in pgbench?
-- If you select the simple-update built-in (also -N), steps 4 and 5 aren't included in the transaction. This will avoid update contention on these tables, but it makes the test case even less like TPC-B.
-- If you select the select-only built-in (also -S), only the SELECT is issued.

WITH
    update_pgbench_accounts AS
        (UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid RETURNING abalance),
    update_pgbench_tellers AS
        (UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid RETURNING NULL),
    update_pgbench_branches AS
        (UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid RETURNING NULL),
    insert_pgbench_history AS
        (INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP) RETURNING NULL)
    SELECT abalance FROM update_pgbench_accounts;
