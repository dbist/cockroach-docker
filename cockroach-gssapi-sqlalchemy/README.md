# A Secure CockroachDB Cluster with Kerberos, Sqlalchemy and HAProxy acting as load balancer
---

Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)
- Part 5: [Executing CockroachDB table import via GSSAPI](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-5.html)
- Part 6: [Three-headed dog meet cockroach, part 6: CockroachDB, MIT Kerberos, HAProxy and Docker Compose](https://blog.ervits.com/2020/08/three-headed-dog-meet-cockroach-part-6.html)
- Part 7: [CockroachDB with MIT Kerberos and Django](https://blog.ervits.com/2020/08/cockroachdb-with-django-and-mit-kerberos.html)
- Part 8: [CockroachDB with MIT Kerberos and SQLAlchemy](https://blog.ervits.com/2020/08/cockroachdb-with-sqlalchemy-and-mit.html)
---

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `kdc` - MIT Kerberos realm
* `web` - sqlaclhemy server

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.
---

The SQLAlchemy application with CockroachDB is based on the CockroachDB SQLAlchemy [tutorial](https://www.cockroachlabs.com/docs/stable/build-a-python-app-with-cockroachdb-sqlalchemy.html). Feel free to read the article [8](#Part 8) above.

1. Start the application

```bash
./up.sh
```

```bash
Creating network "cockroach-gssapi-sqlalchemy_default" with the default driver
Creating network "cockroach-gssapi-sqlalchemy_roachnet" with the default driver
Creating volume "cockroach-gssapi-sqlalchemy_certs-roach-0" with default driver
Creating volume "cockroach-gssapi-sqlalchemy_certs-roach-1" with default driver
Creating volume "cockroach-gssapi-sqlalchemy_certs-roach-2" with default driver
Creating volume "cockroach-gssapi-sqlalchemy_keytab" with default driver
Creating volume "cockroach-gssapi-sqlalchemy_certs-client" with default driver
Creating roach-cert ... done
Creating kdc        ... done
Creating roach-0    ... done
Creating roach-1    ... done
Creating roach-2    ... done
Creating lb         ... done
Creating web        ... done
CREATE ROLE

Time: 8.6299ms

CREATE DATABASE

Time: 15.1892ms

GRANT

Time: 6.4917ms

SET CLUSTER SETTING

Time: 12.3533ms

SET CLUSTER SETTING

Time: 11.2168ms

SET CLUSTER SETTING

Time: 15.9956ms

SET CLUSTER SETTING

Time: 12.6019ms
```

2. Check the logs

```bash
docker logs web
```

```python
2020-08-17 14:29:32,949 INFO sqlalchemy.engine.base.Engine BEGIN (implicit)
2020-08-17 14:29:32,949 INFO sqlalchemy.engine.base.Engine SAVEPOINT cockroach_restart
2020-08-17 14:29:32,950 INFO sqlalchemy.engine.base.Engine {}
2020-08-17 14:29:32,952 INFO sqlalchemy.engine.base.Engine SELECT accounts.id AS accounts_id, accounts.balance AS accounts_balance
FROM accounts
WHERE accounts.id = %(id_1)s
2020-08-17 14:29:32,952 INFO sqlalchemy.engine.base.Engine {'id_1': 95435663}
2020-08-17 14:29:32,955 INFO sqlalchemy.engine.base.Engine UPDATE accounts SET balance=%(balance)s WHERE accounts.id = %(accounts_id)s
2020-08-17 14:29:32,956 INFO sqlalchemy.engine.base.Engine {'balance': 484504, 'accounts_id': 95435663}
2020-08-17 14:29:32,958 INFO sqlalchemy.engine.base.Engine UPDATE accounts SET balance=(accounts.balance + %(balance_1)s) WHERE accounts.id = %(id_1)s
2020-08-17 14:29:32,959 INFO sqlalchemy.engine.base.Engine {'balance_1': 484503, 'id_1': 756738049}
2020-08-17 14:29:32,961 INFO sqlalchemy.engine.base.Engine RELEASE SAVEPOINT cockroach_restart
2020-08-17 14:29:32,961 INFO sqlalchemy.engine.base.Engine {}
2020-08-17 14:29:32,966 INFO sqlalchemy.engine.base.Engine COMMIT
```

3. Check the status of the application

```bash
docker-compose ps
```

```bash
   Name                 Command               State                                         Ports
----------------------------------------------------------------------------------------------------------------------------------------
kdc          /start.sh                        Up
lb           /docker-entrypoint.sh hapr ...   Up      0.0.0.0:26257->26257/tcp, 5432/tcp, 0.0.0.0:8080->8080/tcp, 0.0.0.0:8081->8081/tcp
roach-0      /cockroach/cockroach.sh st ...   Up      26257/tcp, 8080/tcp
roach-1      /cockroach/cockroach.sh st ...   Up      26257/tcp, 8080/tcp
roach-2      /cockroach/cockroach.sh st ...   Up      26257/tcp, 8080/tcp
roach-cert   /bin/sh -c tail -f /dev/null     Up
web          ./sqlalchemy/start.sh            Up      0.0.0.0:8000->8000/tcp
```

4. Connect to CockroachDB and check whether accounts are populated

```bash
docker exec -it roach-0 sh
```

```sql
cockroach sql --certs-dir=/certs --host=lb
#
# Welcome to the CockroachDB SQL shell.
# All statements must be terminated by a semicolon.
# To exit, type: \q.
#
# Server version: CockroachDB CCL v20.1.4 (x86_64-unknown-linux-gnu, built 2020/07/29 22:56:36, go1.13.9) (same version as client)
# Cluster ID: 333acd7f-ec6e-4e47-9b92-4130c8aad13b
# Organization: Cockroach Labs - Production Testing
#
# Enter \? for a brief introduction.
#
root@roach-0:26257/defaultdb> select * from bank.accounts;
     id     | balance
------------+----------
   28585249 |  269455
   76361884 |  638333
...
  997258425 |  181144
(100 rows)

Time: 2.1635ms

root@roach-0:26257/defaultdb> \q
```
