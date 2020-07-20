# Secure CockroachDB Cluster with a load balancer and JupyterLab
A 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `jupyterlab` - JupyterLab node

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1) Operation order is important, execute `./up.sh` instead of `docker-compose up`
   - monitor the status of services via `docker-compose logs`
          use `docker-compose logs <containername>`, `docker-compose kill <containername>`, `docker-compose up -d <containername>`
          to debug and proceed.
2) visit the [CockroachDB UI](https://localhost:8080) and login with username `test` and password `password`
3) visit the [HAProxy UI](http://localhost:8081)
4) visit the JupyterLab webpage by getting the url from `docker logs jupyterlab` command.

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti roach-cert /bin/sh
docker exec -ti jupyterlab /bin/bash
```

5) Access CockroachDB CLI

maxroach user

```bash
docker exec -it roach-0 ./cockroach sql --certs-dir=/certs --host=roach-0:26257 --user=maxroach --database=movr
```

root user

```bash
docker exec -it roach-0 ./cockroach sql --certs-dir=/certs --host=roach-0:26257
```

or with postgresql url, note, this will prompt for password

```bash
docker exec -it roach-0 ./cockroach sql --url 'postgresql://maxroach@roach-0:26257?sslert=/certs/client.maxroach.crt&sslkey=/certs/client.maxroach.key&sslmode=verify-full&sslrootcert=/certs/ca.crt' --database movr
```

### NOTE: Currently requires an older version of Jupyterlab as the most current 2.0.1 reports `jupyterlab-sql` is outdated. See [issue](https://github.com/pbugnion/jupyterlab-sql/issues/131)

### NOTE: passing url to `jupyterlab-sql` in the form `postgresql://maxroach@roach-0:26257?sslert=/certs/client.maxroach.crt&sslkey=/certs/client.maxroach.key&sslmode=verify-full&sslrootcert=/certs/ca.crt` doesn't work. Workaround is `postgresql://maxroach@roach-0?sslert=/certs/client.maxroach.crt&sslkey=/certs/client.maxroach.key&sslmode=verify-full&sslrootcert=/certs/ca.crt&port=26257`, see [issue](https://github.com/pbugnion/jupyterlab-sql/issues/135)

### NOTE: connecting from `jupyterlab` container through python is possible with
```python
from psycopg2 import connect
psql_conn = connect("dbname=movr user=maxroach password=maxroach host=roach-0 sslmode=require port=26257")
psql_conn.close()
```
