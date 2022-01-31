# Sample 3 node *insecure* CockroachDB cluster with HAProxy acting as load balancer and PGBouncer

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `pgbouncer` - Lightweight connection pooling utility
* `client` - client machine containing `cockroach` binary

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1. Start the tutorial using `./up.sh` script

```bash
Creating network "cockroach-pgbouncer_default" with the default driver
Creating roach-0 ... done
Creating roach-1 ... done
Creating roach-2 ... done
Creating lb      ... done
Creating pgbouncer ... done
Creating client    ... done
Cluster successfully initialized
CREATE ROLE

Time: 9ms

GRANT

Time: 87ms
```

2. Connect to cockroach using PGBouncer

PGBouncer is being load balanced via `haproxy`, it can be verified by inspecting `pgbouncer/cockroachdb.env` file.

```bash
DATABASES_HOST=lb
DATABASES_PORT=26257
DATABASES_DBNAME=defaultdb
```

### Connect as root

```bash
docker exec -it client cockroach sql --insecure --url 'postgres://root@pgbouncer:27000'
```

The port for connection string is the PGBouncer port, again inspecting the PGBouncer config file

```bash
PGBOUNCER_LISTEN_PORT=27000
```

### Connect as roach

```bash
docker exec -it client cockroach sql --insecure --url 'postgres://roach@pgbouncer:27000'
```

### passing sslmode to the connection string invalidates the need to pass --insecure

```bash
docker exec -it client cockroach sql --url 'postgres://roach@pgbouncer:27000?sslmode=disable'
```

3. visit the [HAProxy UI](http://localhost:8081)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti client /bin/bash

# shell
docker exec -ti roach-cert /bin/sh

# cli inside the container
cockroach sql --insecure --host=roach-0

# directly
docker exec -ti client cockroach sql --insecure --host=roach-0
```

4. Inspect the PGBouncer logs

```bash
docker logs pgbouncer
```

```bash
Creating pgbouncer config in /etc/pgbouncer
#pgbouncer.ini

[databases]
* = host = lb port=26257 dbname=defaultdb

[pgbouncer]
listen_addr = *
listen_port = 27000
auth_file = /etc/pgbouncer/userlist.txt
auth_type = trust
pool_mode = session
max_client_conn = 200
default_pool_size = 25
ignore_startup_parameters = extra_float_digits

# Log settings
admin_users = root

# Connection sanity checks, timeouts
server_reset_query = false

# TLS settings
client_tls_sslmode = disable

# Dangerous timeouts

Starting pgbouncer.
2021-04-08 15:05:48.921 UTC [1] LOG kernel file descriptor limit: 1048576 (hard: 1048576); max_client_conn: 200, max expected fd use: 212
2021-04-08 15:05:48.921 UTC [1] LOG listening on 0.0.0.0:27000
2021-04-08 15:05:48.921 UTC [1] LOG listening on [::]:27000
2021-04-08 15:05:48.921 UTC [1] LOG listening on unix:/tmp/.s.PGSQL.27000
2021-04-08 15:05:48.921 UTC [1] LOG process up: PgBouncer 1.15.0, libevent 2.1.8-stable (epoll), adns: c-ares 1.15.0, tls: LibreSSL 2.7.5
2021-04-08 15:06:48.854 UTC [1] LOG stats: 0 xacts/s, 0 queries/s, in 0 B/s, out 0 B/s, xact 0 us, query 0 us, wait 0 us
2021-04-08 15:07:48.787 UTC [1] LOG stats: 0 xacts/s, 0 queries/s, in 0 B/s, out 0 B/s, xact 0 us, query 0 us, wait 0 us
2021-04-08 15:08:48.719 UTC [1] LOG stats: 0 xacts/s, 0 queries/s, in 0 B/s, out 0 B/s, xact 0 us, query 0 us, wait 0 us
2021-04-08 15:09:11.049 UTC [1] LOG C-0x5585e0a471b0: (nodb)/(nouser)@192.168.48.7:55214 registered new auto-database: db=roach
2021-04-08 15:09:11.049 UTC [1] LOG C-0x5585e0a471b0: roach/roach@192.168.48.7:55214 login attempt: db=roach user=roach tls=no
2021-04-08 15:09:11.050 UTC [1] LOG S-0x5585e0aa9870: roach/roach@192.168.48.5:26257 new connection to server (from 192.168.48.6:58200)
```

### Run a workload via LB and/or PGBouncer

#### LB

```bash
docker exec -it client cockroach workload init tpcc --split 'postgresql://root@lb:26257/tpcc?sslmode=disable'
```

## PGBouncer

```bash
docker exec -it client cockroach workload run tpcc --duration=120m --concurrency=3 --max-rate=1000 --tolerate-errors 'postgresql://root@pgbouncer:27000/tpcc?sslmode=disable'
```
