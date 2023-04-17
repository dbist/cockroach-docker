# Sample 3 node *insecure* CockroachDB cluster with HAProxy acting as load balancer and pgcat

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `pgcat` - Lightweight connection pooling utility
* `client` - client machine containing `cockroach` binary

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1. Start the tutorial using `./up.sh` script

```bash
Creating network "cockroach-pgcat_default" with the default driver
Creating roach-0 ... done
Creating roach-1 ... done
Creating roach-2 ... done
Creating lb      ... done
Creating pgcat ... done
Creating client    ... done
Cluster successfully initialized
```

2. Connect to cockroach using pgcat

pgcat config file `pgcat.toml`.

# Access SQL CLI via pgcat

```bash
docker exec -it client cockroach sql --url 'postgres://pgcat:6432/tpcc?sslmode=disable'
```

or

```bash
docker exec -it client cockroach sql --insecure --host=pgcat --port=6432 --database=tpcc
```

### Run a workload via LB and/or PGBouncer

## initialize workload with transaction pool

```bash
docker exec -it client cockroach workload fixtures import tpcc --warehouses=10 'postgresql://root@pgcat:6432/tpcc?sslmode=disable'
I221114 21:03:32.556426 1 ccl/workloadccl/fixture.go:318  [-] 1  starting import of 9 tables
W221114 21:03:32.822631 1 ccl/workloadccl/fixture.go:534  [-] 2  error enabling automatic stats: driver: bad connection
Error: importing fixture: importing table warehouse: pq: unknown prepared statement ""
```

you must use the `session` pool_mode to initialize tpcc or use the load balancer url.

```bash
docker exec -it client cockroach workload fixtures import tpcc --warehouses=10 'postgresql://root@pgcat:6432/tpcc?sslmode=disable'
```

## pgcat: execute the tpcc workload

```bash
docker exec -it client cockroach workload run tpcc --duration=120m --concurrency=3 --max-rate=1000 --tolerate-errors --warehouses=10 --conns 60 --ramp=1m --workers=100 'postgresql://root@pgcat:6432/tpcc?sslmode=disable'
```
