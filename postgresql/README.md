# Sample 3 node *insecure* CockroachDB cluster with HAProxy acting as load balancer and pgbench

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `pgbench` - PostgreSQL benchmarking utility
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
Creating pgbench ... done
Creating client    ... done
Cluster successfully initialized
CREATE ROLE

Time: 9ms

GRANT

Time: 87ms
```

### Connect as root

```bash
docker exec -it client cockroach sql --insecure --url 'postgres://root@lb:26257/defaultdb&sslmode=disable'
```

2. visit the [HAProxy UI](http://localhost:8081)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti client /bin/bash
docker exec -ti pgbench /bin/bash

# cli inside the container
cockroach sql --insecure --host=lb

# directly
docker exec -ti client cockroach sql --insecure --host=roach-0
```

3. Inspect the pgbench logs

```bash
docker logs pgbench
```

4. Inspect all of the container logs

```bash
docker compose logs --follow
```

5. Run the workload

Initialize

```bash
pgbench \
 --initialize \
 --host=${PGHOST} \
 --username=${PGUSER} \
 --port=${PGPORT} \
 --no-vacuum \
 --scale=${SCALE} \
 ${PGDATABASE}
```

Run the default `tpcb-like` workload

```bash
pgbench \
 --host=${PGHOST} \
 --no-vacuum \
 --file=original.sql@1 \
 --client=8 \
 --jobs=8 \
 --username=${PGUSER} \
 --port=${PGPORT} \
 --scale=${SCALE} \
 --failures-detailed \
 --verbose-errors \
 --max-tries=3 \
 ${PGDATABASE} \
 -T 60 \
 -P 5
```

Run the optimized workload

```bash
pgbench \
 --host=${PGHOST} \
 --no-vacuum \
 --file=final.sql@1 \
 --client=25 \
 --jobs=8 \
 --username=${PGUSER} \
 --port=${PGPORT} \
 --scale=${SCALE} \
 --failures-detailed \
 --verbose-errors \
 --max-tries=3 \
 ${PGDATABASE} \
 -T 60 \
 -P 5
```
