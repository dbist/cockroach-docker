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
DATABASES_DBNAME=tpcc
```

## Connect to PGBouncer from client, will connect to the database specified by the database PGBouncer is configured to

Connect to `cockroach sql` cli using explicit connection, note, client cert for roach is generated using PGBouncer CA, root will need its own PGBouncer CA generated cert.

```bash
docker exec -it client cockroach sql --certs-dir=/shared/certs --host=pgbouncer --port=27000 --user=roach
```

### Load the TPCC workload

This will load 2 GB of data for 10 warehouses, follow the tutorial [here](https://www.cockroachlabs.com/docs/v20.2/performance-benchmarking-with-tpcc-local.html)

```bash
docker exec -it client cockroach workload fixtures import tpcc \
 --warehouses=10 'postgresql://roach@lb:26257/tpcc?sslcert=/certs%2Fclient.roach.crt&sslkey=/certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=/certs%2Fca.crt'
```

### Run the workload

```bash
docker exec -it client cockroach workload run tpcc \
--warehouses=10 \
--active-warehouses=10 \
--ramp=3m \
--duration=10m \
--workers=100 \
--tolerate-errors \
'postgresql://roach@pgbouncer:27000/tpcc?sslcert=/shared/certs%2Fclient.roach.crt&sslkey=/shared/certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=/shared/certs%2Fca.crt'
```

### with concurrency=10

```bash
Initializing 20 connections...
Initializing 100 workers and preparing statements...
I210422 15:35:56.138478 1 workload/cli/run.go:387  creating load generator... done (took 1.3393289s)
```

3. visit the [HAProxy UI](http://localhost:8081)

4. Inspect the PGBouncer logs

```bash
docker logs pgbouncer
```

## Connecting to non-PGBouncer connections can be done the following ways

```
docker exec -it client cockroach sql --certs-dir=/certs --host=lb --user=roach
```

```
docker exec -it client cockroach sql --certs-dir=/certs --url "postgresql://roach@lb:26257/defaultdb?sslmode=verify-full"
```
