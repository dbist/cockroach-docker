\set aid random(1, 100000 * :scale)
\set delta random(0, 100 * :scale)
\set tid random(0, 10 * :scale)
\set bid random(0, 100 * :scale)

-- https://www.postgresql.org/docs/13/pgbench.html
-- What Is the “Transaction” Actually Performed in pgbench?
-- If you select the simple-update built-in (also -N), steps 4 and 5 aren't included in the transaction. This will avoid update contention on these tables, but it makes the test case even less like TPC-B.
-- If you select the select-only built-in (also -S), only the SELECT is issued.

-- 1
BEGIN;

-- 2
UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid;

-- 3
SELECT abalance FROM pgbench_accounts WHERE aid = :aid;

-- 4
UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid;

-- 5
UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid;

-- 6
INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP);

-- 7
END;
