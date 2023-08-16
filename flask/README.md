# Secure CockroachDB Cluster with Flask, inspired by the [Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-use-a-postgresql-database-in-a-flask-application) tutorial.

Simple 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `flask` - Flask container

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.


start the environment using

```bash
docker compose -f docker-compose-secure.yml -f docker-compose-flask.yml up -d --build
```

   - monitor the status of services via `docker-compose logs`
   - in case you need to adjust something in composexample/settings.py, you can
          use `docker-compose logs flask`, `docker-compose kill flask`, `docker-compose up -d flask`
          to debug and proceed.
4) visit the [CockroachDB UI](https://localhost:8080) and login with username `roach` and password `roach`
5) visit the [HAProxy UI](http://localhost:8081)
6) visit the [Flask](http://flask:8000) webpage

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti roach-cert /bin/sh
docker exec -ti client /bin/bash
```

