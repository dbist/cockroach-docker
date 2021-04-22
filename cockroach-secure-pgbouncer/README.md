# Sample 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer and PGBouncer for connection pooling

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

5. Connect to `cockroach sql` cli using explicit connection, note, client cert for roach is generated using PGBouncer CA, root will need its own PGBouncer CA generated cert.

```
docker exec -it pgbouncer cockroach sql --certs-dir=certs --host=pgbouncer --port=27000 --user=roach
```

```
docker exec -it pgbouncer cockroach sql --certs-dir=certs --url "postgresql://roach@pgbouncer:27000/defaultdb?sslmode=verify-full"
```

## Run a tpcc workload using PGBouncer connection

```
docker exec -it pgbouncer cockroach workload run tpcc --duration=120m --concurrency=5 --warehouses 5 --drop --max-rate=1000 --tolerate-errors 'postgresql://roach@pgbouncer:27000/tpcc?sslcert=certs%2Fclient.roach.crt&sslkey=certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt&application_name=pgbouncer'
```

6. Connecting to non-PGBouncer connections can be done the following ways

```
docker exec -it client cockroach sql --certs-dir=/certs --host=lb --user=roach
```

```
docker exec -it client cockroach sql --certs-dir=/certs --url "postgresql://roach@lb:26257/defaultdb?sslmode=verify-full"
```
