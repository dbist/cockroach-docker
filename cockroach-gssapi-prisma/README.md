# A Secure CockroachDB Cluster with Kerberos and HAProxy acting as load balancer
---

Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)
- Part 5: [Executing CockroachDB table import via GSSAPI](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-5.html)
- Part 6: [CockroachDB, MIT Kerberos, HAProxy and Docker Compose](https://blog.ervits.com/2020/08/three-headed-dog-meet-cockroach-part-6.html)
- Part 7: [CockroachDB with Django and MIT Kerberos](https://blog.ervits.com/2020/08/cockroachdb-with-django-and-mit-kerberos.html)
- Part 8: [CockroachDB with SQLAlchemy and MIT Kerberos](https://blog.ervits.com/2020/08/cockroachdb-with-sqlalchemy-and-mit.html)
- Part 9: [CockroachDB with MIT Kerberos using a native client](https://blog.ervits.com/2020/10/cockroachdb-with-mit-kerberos-using.html)
- Part 10: [CockroachDB with MIT Kerberos along with cert user authentication](https://blog.ervits.com/2021/06/cockroachdb-with-mit-kerberos-along.html)
- Part 11: [CockroachDB with GSSAPI deployed via systemd](https://blog.ervits.com/2021/07/cockroachdb-with-gssapi-deployed-via.html)
- Part 12: [Selecting proper cipher for CockroachDB with GSSAPI](https://blog.ervits.com/2021/07/selecting-proper-encryption-type-for.html)
- Part 13: [Overriding KRB5CCNAME for CockroachDB with GSSAPI](https://blog.ervits.com/2021/07/cockroachdb-with-gssapi-overriding.html)

---

## Services

* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `kdc` - MIT Kerberos realm
* `client` - cockroach client node, also has `psql` installed

## Getting started

>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

### Open Interactive Shells

```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti client /bin/bash
docker exec -ti kdc sh

docker exec -ti client cockroach sql --certs-dir=/certs --host=lb
```

1) execute `./up.sh` instead of `docker compose up`
   - monitor the status of services via `docker compose logs`
2) visit the [DB Console](http://localhost:8080)
3) visit the [HAProxy UI](http://localhost:8081)

4) Connecting to CockroachDB using the native binary

```bash
docker exec -it client \
cockroach sql --certs-dir=/certs --host=lb.local --user=tester
```

```bash
#
# Welcome to the CockroachDB SQL shell.
# All statements must be terminated by a semicolon.
# To exit, type: \q.
#
# Server version: CockroachDB CCL v21.2.0 (x86_64-unknown-linux-gnu, built 2021/11/15 13:58:04, go1.16.6) (same version as client)
# Cluster ID: 71429258-dbc1-4fda-afb8-7a2d4920681c
# Organization: Cockroach Labs - Production Testing
#
# Enter \? for a brief introduction.
#
tester@lb.local:26257/defaultdb>
```

5) Connecting with native client and `--url` flag

```bash
docker exec -it client cockroach sql \
 --certs-dir=/certs --url  "postgresql://tester:nopassword@lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn"
```

6) Connect to `cockroach` using `psql`

__NOTE__: Directly connecting to `psql` from host fails

```bash
docker exec -it client psql "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```bash
psql: error: connection to server at "lb" (172.28.0.6), port 26257 failed: connection to server at "lb" (172.28.0.6), port 26257 failed: ERROR:  unimplemented: unimplemented client encoding: "sqlascii"
HINT:  You have attempted to use a feature that is not yet implemented.
See: https://go.crdb.dev/issue-v/35882/v21.2
```

see this [issue](https://github.com/cockroachdb/cockroach/issues/37129)

Must shell into the container for psql

```bash
docker exec -it client bash
```

```bash
psql "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```sql
psql (14.1, server 13.0.0)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_128_GCM_SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=>
```

using native binary

```bash
./cockroach sql --host=lb.local --certs-dir=/certs --user tester
```

7) Connect to `cockroach` using `psql` and `krbsrvname`

```bash
psql "postgresql://lb.local:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester
```

8) Connect to Cockroach using `psql` with parameters

```bash
 psql "host=lb port=26257 dbname=defaultdb user=tester"
```

or

```bash
 psql "host=lb.local port=26257 dbname=defaultdb user=tester"
```




##### PRISMA #####

currently fails on

```bash
Environment variables loaded from .env
Prisma schema loaded from prisma/schema.prisma
Datasource "db": CockroachDB database "defaultdb", schema "public" at "lb.local:26257"

Introspecting based on datasource defined in prisma/schema.prisma …

Error: Error in connector: Error querying the database: Error querying the database: Error querying the database: authentication error: unsupported authentication method
```

to reproduce

```bash
./up.sh

docker exec -it prisma bash

npx prisma db pull
```


```bash
docker logs prisma --follow
```

```bash
Password for tester@EXAMPLE.COM:
NODE_VERSION=17.4.0
HOSTNAME=prisma
YARN_VERSION=1.22.17
HOME=/root
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/cockroachdb
REFRESHED_AT=2022_02_07
CREATE DATABASE
SET
CREATE TABLE
CREATE TABLE
CREATE TABLE
GRANT
```

additionally, we can set debug mode on for Prisma with

```bash
export DEBUG="*"
```

```bash
root@prisma:/cockroachdb# npx prisma db pull
  prisma:loadEnv project root found at /cockroachdb/package.json +0ms
  prisma:tryLoadEnv Environment variables loaded from /cockroachdb/.env +0ms
Environment variables loaded from .env
  prisma:engines binaries to download libquery-engine, migration-engine, introspection-engine, prisma-fmt +0ms
Prisma schema loaded from prisma/schema.prisma
  prisma:getConfig Using CLI Query Engine (Node-API Library) at: /cockroachdb/node_modules/@prisma/engines/libquery_engine-debian-openssl-1.1.x.so.node +0ms
Datasource "db": CockroachDB database "defaultdb", schema "public" at "lb.local:26257"

Introspecting based on datasource defined in prisma/schema.prisma …
  prisma:introspectionEngine:rpc starting introspection engine with binary: /cockroachdb/node_modules/@prisma/engines/introspection-engine-debian-openssl-1.1.x +0ms
  prisma:introspectionEngine:rpc SENDING RPC CALL {"id":1,"jsonrpc":"2.0","method":"introspect","params":[{"schema":"generator client {\n  provider        = \"prisma-client-js\"\n  previewFeatures = [\"cockroachdb\"]\n}\n\ndatasource db {\n  provider = \"cockroachdb\"\n  url      = env(\"DATABASE_URL\")\n}\n"}]} +7ms
  prisma:introspectionEngine:rpc {
  prisma:introspectionEngine:rpc   jsonrpc: '2.0',
  prisma:introspectionEngine:rpc   error: {
  prisma:introspectionEngine:rpc     code: 4466,
  prisma:introspectionEngine:rpc     message: 'An error happened. Check the data field for details.',
  prisma:introspectionEngine:rpc     data: {
  prisma:introspectionEngine:rpc       is_panic: false,
  prisma:introspectionEngine:rpc       message: 'Error in connector: Error querying the database: Error querying the database: Error querying the database: authentication error: unsupported authentication method',
  prisma:introspectionEngine:rpc       backtrace: null
  prisma:introspectionEngine:rpc     }
  prisma:introspectionEngine:rpc   },
  prisma:introspectionEngine:rpc   id: 1
  prisma:introspectionEngine:rpc } +17ms

Error: Error: Error in connector: Error querying the database: Error querying the database: Error querying the database: authentication error: unsupported authentication method

    at Object.<anonymous> (/cockroachdb/node_modules/prisma/build/index.js:46490:29)
    at Object.handleResponse (/cockroachdb/node_modules/prisma/build/index.js:46368:38)
    at LineStream4.<anonymous> (/cockroachdb/node_modules/prisma/build/index.js:46446:20)
    at LineStream4.emit (node:events:520:28)
    at addChunk (node:internal/streams/readable:324:12)
    at readableAddChunk (node:internal/streams/readable:297:9)
    at LineStream4.Readable.push (node:internal/streams/readable:234:10)
    at LineStream4._pushBuffer (/cockroachdb/node_modules/prisma/build/index.js:46211:21)
    at LineStream4._transform (/cockroachdb/node_modules/prisma/build/index.js:46205:12)
    at LineStream4.Transform._write (node:internal/streams/transform:184:23
```
