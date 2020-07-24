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
