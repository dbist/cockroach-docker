# Sample CockroachDB application using CockroachDB, MIT Kerberos and postgresql-client
---

Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)

---
TODO:
1. Add kerberos support

---
1. Run `./up.sh`
2. Tear it down with `./down.sh`
3. Connect to the `kdc` container using `docker exec -it kdc bin/sh`

```bash
# kadmin.local
Authenticating as principal root/admin@EXAMPLE.COM with password.
kadmin.local:  list_principals
K/M@EXAMPLE.COM
kadmin/admin@EXAMPLE.COM
kadmin/changepw@EXAMPLE.COM
kadmin/e543e5072daf@EXAMPLE.COM
kiprop/e543e5072daf@EXAMPLE.COM
krbtgt/EXAMPLE.COM@MY.EX
postgres/cockroach@EXAMPLE.COM
tester@EXAMPLE.COM
kadmin.local:
```

4. Connect to the cockroach node

```bash
docker exec -it cockroach bash
```

5. Connect to sql shell with fallback root user and cert

```bash
cockroach sql --certs-dir=/certs --host=cockroach
```

6. Connect to the node container

```bash
docker exec -it nodeapp bash
```

7. Check the node app works

```bash
docker logs nodeapp
```

```bash
Password for tester@EXAMPLE.COM:
NODE_VERSION=14.5.0
HOSTNAME=nodeapp
YARN_VERSION=1.22.4
HOME=/root
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/app
REFRESHED_AT=2020_07_24
Initial balances:
{ id: '1', balance: '1000' }
{ id: '2', balance: '250' }
```

8. To run a kerberos example
a) edit the `nodejs/app/start.sh` script and comment out the line with `basic-sample.js`, uncomment the `kerberos-sample.js`

Error message with kerberos is below, `node-postgres` does not have any indication how to run a kerberos example.

```bash
Password for tester@EXAMPLE.COM:
NODE_VERSION=14.5.0
HOSTNAME=nodeapp
YARN_VERSION=1.22.4
HOME=/root
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/app
REFRESHED_AT=2020_07_24
could not connect to cockroachdb error: password authentication failed for user tester
    at Parser.parseErrorMessage (/app/node_modules/pg-protocol/dist/parser.js:278:15)
    at Parser.handlePacket (/app/node_modules/pg-protocol/dist/parser.js:126:29)
    at Parser.parse (/app/node_modules/pg-protocol/dist/parser.js:39:38)
    at TLSSocket.<anonymous> (/app/node_modules/pg-protocol/dist/index.js:8:42)
    at TLSSocket.emit (events.js:314:20)
    at addChunk (_stream_readable.js:304:12)
    at readableAddChunk (_stream_readable.js:280:9)
    at TLSSocket.Readable.push (_stream_readable.js:219:10)
    at TLSWrap.onStreamRead (internal/stream_base_commons.js:188:23) {
  length: 102,
  severity: 'ERROR',
  code: 'XXUUU',
  detail: undefined,
  hint: undefined,
  position: undefined,
  internalPosition: undefined,
  internalQuery: undefined,
  where: undefined,
  schema: undefined,
  table: undefined,
  column: undefined,
  dataType: undefined,
  constraint: undefined,
  file: 'auth.go',
  line: '97',
  routine: 'handleAuthentication'
}
}
```
