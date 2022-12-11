# Sample 3 node *insecure* CockroachDB cluster with HAProxy acting as load balancer and a sample dotnet [application](https://www.cockroachlabs.com/docs/stable/build-a-csharp-app-with-cockroachdb.html?filters=local)

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `pgbouncer` - Lightweight connection pooling utility
* `client` - client machine containing `cockroach` binary
* `app` - dotnet application

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

2. visit the [HAProxy UI](http://localhost:8081)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti client /bin/bash

# cli inside the container
cockroach sql --insecure --host=lb

# directly
docker exec -ti client cockroach sql --insecure --host=lb
```

3. Inspect the app

```bash
docker logs app
```
