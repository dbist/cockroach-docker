# Basic CockroachDB Cluster with HAProxy and Django.
Django tutorial is based on the [tutorial](https://docs.docker.com/compose/django/) from Docker.
Simple 3 node CockroachDB cluster with HAProxy acting as load balancer
Based on Tim Veil's awesome `docker-compose` [recipes](https://github.com/timveil-cockroach/docker-examples/tree/master) for CockroachDB.

## Services
* `web`    - Django node
* `crdb-0` - CockroachDB node
* `crdb-1` - CockroachDB node
* `crdb-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer

## Getting started
1) run `docker-compose up`
2) visit the CockroachDB UI @ http://localhost:8080
2) visit the HAProxy UI @ http://localhost:8081
3) have fun!

## Helpful Commands

### Execute SQL
Use the following to execute arbitrary SQL on the CockroachDB cluster.  The following creates a database called `test`.
```bash
docker-compose exec crdb-0 /cockroach/cockroach sql --insecure --execute="CREATE DATABASE test;"
```

### Open Interactive Shells
```bash
docker exec -ti crdb-0 ./cockroach sql 
docker exec -ti crdb-1 ./cockroach sql
docker exec -ti crdb-2 ./cockroach sql
docker exec -ti lb /bin/sh
docker exec -ti web /bin/sh
```

### Stop Individual nodes
```bash
docker-compose stop crdb-0
docker-compose stop crdb-1
docker-compose stop crdb-2
```

### Terminate and purge the environment
```bash
docker-compose down
```
