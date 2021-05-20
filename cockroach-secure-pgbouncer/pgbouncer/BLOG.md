# PGBouncer with CockroachDB

---

I've tested Cockroach with `session` mode primarily. [PGBouncer FAQ](https://www.pgbouncer.org/faq.html) states that prepared statements will not reset on connections. We must clean up old prepared statements in this mode. This can be achieved by `server_reset_query = DISCARD ALL;` or at least to `DEALLOCATE ALL;` In `transaction` mode, we lose ability to leverage prepared statements, in fact, we have to disable them alltogether.

