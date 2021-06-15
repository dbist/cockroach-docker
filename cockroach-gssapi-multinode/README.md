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

---

## Services

  `roach-0` - CockroachDB node
  `roach-1` - CockroachDB node
  `roach-2` - CockroachDB node
  `lb` - HAProxy acting as load balancer
  `roach-cert` - Holds certificates as volume mounts
  `kdc` - MIT Kerberos realm
  `client` - cockroach client node, also has `psql` installed

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

1. execute `./up.sh` instead of `docker compose up`
   - monitor the status of services via `docker compose logs`
2. visit the [DB Console](http://localhost:8080)
3. visit the [HAProxy UI](http://localhost:8081)

4. Connect to `cockroach` using `psql`

__Disclaimer__: given weird behavior on my host, I am unable to execute the below command on the latest CockroachDB

```bash
docker exec -it client
psql "postgresql://lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```sql
psql: error: ERROR:  unimplemented: unimplemented client encoding: "sqlascii"
HINT:  You have attempted to use a feature that is not yet implemented.
See: https://go.crdb.dev/issue-v/35882/v21.1
```

Shelling into the container and connecting works though

```bash
docker exec -it client bash
```

```bash
psql "postgresql://lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```sql
psql (13.3, server 13.0.0)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_128_GCM_SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=> 
```

#### Connect to `cockroach` using `psql` and `krbsrvname`

```bash
psql "postgresql://lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester
```

#### Connecting to CockroachDB using the native binary

```bash
docker exec -it client cockroach sql \
 --certs-dir=/certs --url  "postgresql://tester:nopassword@lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn"
```