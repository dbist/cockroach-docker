# A Secure CockroachDB Cluster with Kerberos, Sqlalchemy and HAProxy acting as load balancer
---

Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)
- Part 5: [Executing CockroachDB table import via GSSAPI](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-5.html)
- Part 6: [Three-headed dog meet cockroach, part 6: CockroachDB, MIT Kerberos, HAProxy and Docker Compose](https://blog.ervits.com/2020/08/three-headed-dog-meet-cockroach-part-6.html)
- Part 7: [CockroachDB with MIT Kerberos and Django](https://blog.ervits.com/2020/08/cockroachdb-with-django-and-mit-kerberos.html)
- Part 8: [CockroachDB with MIT Kerberos and SqlAlchemy]() 
---

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `kdc` - MIT Kerberos realm
* `web` - sqlaclhemy server

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.
---

The SqlAlchemy application with CockroachDB is based on the CockroachDB SqlAlchemy [tutorial](https://www.cockroachlabs.com/docs/stable/build-a-python-app-with-cockroachdb-sqlalchemy.html). Feel free to read the article [8](#Part 8) above.

1. Start the application

```bash
./up.sh
```

2. Check the logs

```bash
docker logs web
```

3. Check the status of the application

```bash
docker-compose ps
```

