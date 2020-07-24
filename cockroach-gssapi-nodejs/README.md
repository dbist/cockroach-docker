# Sample CockroachDB application using CockroachDB, MIT Kerberos and postgresql-client

TODO:
1. Add kerberos support

------------------------------------------------------
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
