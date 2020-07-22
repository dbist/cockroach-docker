# Sample CockroachDB application using CockroachDB, MIT Kerberos and postgresql-client

TODO:
1. address dockerlint issues
2. add `import` over `psql` example
3. add multi-node cockroach cluster

------------------------------------------------------
1. Run `./up.sh`
2. Connect to the `psql` container using `docker exec -it psql bash`.
3. Connect to cockroach via psql with `psql "postgresql://cockroach:26257/defaultdb?sslmode=require" -U tester`
4. Tear it down with `./down.sh`


```sql
psql (9.5.22, server 9.5.0)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES128-GCM-SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=>
```

5. Connect to the `kdc` container using `docker exec -it kdc bin/sh`

```bash
# kadmin.local
Authenticating as principal root/admin@MY.EX with password.
kadmin.local:  list_principals
K/M@MY.EX
kadmin/admin@MY.EX
kadmin/changepw@MY.EX
kadmin/e543e5072daf@MY.EX
kiprop/e543e5072daf@MY.EX
krbtgt/MY.EX@MY.EX
postgres/cockroach@MY.EX
tester@MY.EX
kadmin.local:
```

6. Connect to the cockroach node

```bash
docker exec -it cockroach bash
```

7. Connect to sql shell with fallback root user and cert

```bash
cockroach sql --certs-dir=/certs --host=cockroach
```

From the `psql` container, the fallback connection string is below

```bash
psql "postgresql://cockroach:26257?sslcert=/certs%2Fclient.root.crt&sslkey=/certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=/certs%2Fca.crt"
```

8. If for any reason you'd like to re-authenticate with Kerberos, using `psql` container and tester user password [[psql]]:

```bash
kdestroy -A
kinit tester
```

9. Using `krbsrvname` to override `postgres` SPN (service principal name) requires a new entry in Kerberos and the associated keytab

```bash
kadmin.local -q "addprinc -randkey customspn/cockroach@MY.EX
kadmin.local -q "ktadd -k /keytab/crdb.keytab customspn/cockroach@MY.EX"
```
then, simply connect to cockroach from the `psql` container using

```bash
psql "postgresql://cockroach:26257/defaultdb?sslmode=require&krbsrvname=customspn" -U tester
```

In case you're not convinced that it takes effect, here's an example with an SPN that does not exist

```bash
psql "postgresql://cockroach:26257/defaultdb?sslmode=require&krbsrvname=doesnotexist" -U tester
psql: GSSAPI continuation error: Unspecified GSS failure.  Minor code may provide more information
GSSAPI continuation error: Server doesnotexist/cockroach@MY.EX not found in Kerberos database
```

10. `IMPORT` over gssapi and psql can be done with the following steps

a. start a webserver on your host and capture the IP and port

```bash
python3 -m http.server
```
b. take the import.sql file and copy it to the psql container

```bash
docker cp import/import.sql psql:/
```

c. grant access to the `tester` user to perform imports as it requires `admin` priveleges

First connect with root user

```bash
psql "postgresql://cockroach:26257/defaultdb?sslmode=require&krbsrvname=customspn" -U tester
```
then execute the grant

```sql
GRANT ADMIN TO tester;
```

d. Finally, execute the import command with the following step

```bash
psql "postgresql://cockroach:26257/defaultdb?sslmode=require&krbsrvname=customspn" -U tester -f import.sql
```

```bash
# psql "postgresql://cockroach:26257/defaultdb?sslmode=require&krbsrvname=customspn" -U tester -f import.sql
DROP TABLE
       job_id       |  status   | fraction_completed | rows | index_entries | bytes
--------------------+-----------+--------------------+------+---------------+-------
 574691207820935169 | succeeded |                  1 | 1000 |          1000 | 41030
(1 row)
```
