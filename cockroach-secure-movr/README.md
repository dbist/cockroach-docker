# Secure CockroachDB Cluster
Simple 1 node *secure* CockroachDB cluster

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-cert` - Holds certificates as volume mounts

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`. 

1) because operation order is important, execute `./up.sh` instead of `docker-compose up`
	- monitor the status of services via `docker-compose logs`
2) visit the CockroachDB UI @ https://localhost:8080 and login with username `test` and password `password`

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-cert /bin/sh
```

3) connect to CRDB CLI directly

```bash
docker exec -it roach-0 ./cockroach sql --url 'postgresql://maxroach@roach-0:26257?sslert=/certs/client.maxroach.crt&sslkey=/certs/client.maxroach.key&sslmode=verify-full&sslrootcert=/certs/ca.crt' --database movr
```

or 

```bash
docker exec -it roach-0 ./cockroach sql --certs-dir=/certs --host=roach-0:26257
```
