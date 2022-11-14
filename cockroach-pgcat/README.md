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
Creating network "cockroach-pgbouncer_default" with the default driver
Creating roach-0 ... done
Creating roach-1 ... done
Creating roach-2 ... done
Creating lb      ... done
Creating pgcat ... done
Creating client    ... done
Cluster successfully initialized
```

2. Connect to cockroach using pgcat

pgcat config file `pgcat.toml` file.

### Connect as root

```bash
docker exec -it client cockroach sql --insecure --url 'postgres://root@pgcat:6432?sslmode=disable'
```

```bash
#
# Welcome to the CockroachDB SQL shell.
# All statements must be terminated by a semicolon.
# To exit, type: \q.
#
ERROR: server closed the connection.
Is this a CockroachDB node?
EOF
Failed running "sql"
```

The logs say

```bash
[2022-11-14T20:18:45.620009Z INFO  pgcat::pool] Creating a new server connection Address { id: 3, host: "lb", port: 26257, shard: 1, database: "defaultdb", role: Replica, replica_number: 0, address_index: 1, username: "root", pool_name: "postgres" }
[2022-11-14T20:18:45.624554Z DEBUG pgcat::server] Server connection marked for clean up
[2022-11-14T20:20:06.564588Z WARN  pgcat] Client disconnected with error ClientError
```

# cli inside the container
cockroach sql --insecure --host=roach-0

# directly
docker exec -ti client cockroach sql --insecure --host=roach-0
```
