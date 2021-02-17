# Postgres migration to CockroachDB
Simple 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

* UPDATED: 02/17/21

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `db` - Postgres container

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1) Start project by executing `./up.sh` instead of `docker-compose up`
   - monitor the status of services via `docker-compose logs`
2) visit the CockroachDB [Admin UI](https://localhost:8080) and login with username `roach` and password `roach`
3) visit the [HAProxy UI](http://localhost:8081)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh

# shell
docker exec -ti roach-cert /bin/sh

# cli inside the container
cockroach sql --certs-dir=/certs --host=roach-0

# directly
docker exec -ti roach-0 cockroach sql --certs-dir=/certs --host=roach-0
```

## accessing postgres
docker-compose exec db psql --u roach
