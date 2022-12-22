# Sample 3 node *insecure* CockroachDB cluster with HAProxy acting as load balancer and PostgreSQL client, which includes `psql`, `pgbench`, etc.

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `postgresql` - PostgreSQL container including psql and pgbench
* `client` - client machine containing `cockroach` binary

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1. Start the tutorial with a helper script from the parent directory.

```bash
cd cockroach-docker
./up.sh docker-compose-postgresql.yml

Creating network "cockroach-docker_default" with the default driver
Creating roach-0 ... done
Creating roach-1 ... done
Creating roach-2 ... done
Creating lb      ... done
Creating postgresql ... done
Creating client    ... done
Cluster successfully initialized
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
docker exec -ti postgresql /bin/bash

# cli inside the container
cockroach sql --insecure --host=lb

# directly
docker exec -ti client cockroach sql --insecure --host=roach-0
```

3. Inspect the pgbench logs

```bash
docker logs postgresql
```

4. Inspect all of the container logs

```bash
docker compose logs -f docker-compose-postgresql.yml --follow
```

5. Create the sample database

```bash
psql -c "CREATE DATABASE example IF NOT EXISTS;"
```

6. Run the workload

Initialize

```bash
pgbench \
 --initialize \
 --host=${PGHOST} \
 --username=${PGUSER} \
 --port=${PGPORT} \
 --no-vacuum \
 --scale=${SCALE} \
 --foreign-keys \
 ${PGDATABASE}
```

Run the default `tpcb-like` workload

```bash
pgbench \
 --host=${PGHOST} \
 --no-vacuum \
 --file=tpcb-original.sql@1 \
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
 --file=tpcb-cockroach.sql@1 \
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
