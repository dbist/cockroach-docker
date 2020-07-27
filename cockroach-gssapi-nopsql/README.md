# Sample CockroachDB application using CockroachDB, MIT Kerberos and native `cockroach` GSSAPI client authentication

------------------------------------------------------
1. Run `./up.sh`
2. Connect to the `client` container using `docker exec -it client bash`.
3. Connect to cockroach with `cockroach sql --url "postgresql://tester:nopassword@cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt"` and with custom SPN, `cockroach sql --url "postgresql://tester:nopassword@cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn"`
4. Tear it down with `./down.sh`


```sql
# Welcome to the CockroachDB SQL shell.
# All statements must be terminated by a semicolon.
# To exit, type: \q.
#
# Client version: CockroachDB CCL v20.2.0-alpha.1-1529-g069d328c2d-dirty (x86_64-unknown-linux-gnu, built 2020/07/27 16:49:42, go1.14.4)
# Server version: CockroachDB CCL v20.1.3 (x86_64-unknown-linux-gnu, built 2020/06/23 08:44:08, go1.13.9)

warning: server version older than client! proceed with caution; some features may not be available.

# Cluster ID: a7ac9a3a-148a-4c82-bd64-2e56e9bd5eee
# Organization: Cockroach Labs - Production Testing
#
# Enter \? for a brief introduction.
#
tester@cockroach:26257/defaultdb>
```

5. Connect to the `kdc` container using `docker exec -it kdc bin/sh`

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

6. Connect to the cockroach node

```bash
docker exec -it cockroach bash
```

7. Connect to sql shell with fallback root user and cert

```bash
cockroach sql --certs-dir=/certs --host=cockroach
```

From the `` container, the fallback connection string is below

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
kadmin.local -q "addprinc -randkey customspn/cockroach@EXAMPLE.COM
kadmin.local -q "ktadd -k /keytab/crdb.keytab customspn/cockroach@EXAMPLE.COM"
```
then, simply connect to cockroach from the `psql` container using

```bash
psql "postgresql://cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester
```

In case you're not convinced that it takes effect, here's an example with an SPN that does not exist

```bash
psql "postgresql://cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=doesnotexist" -U tester
psql: GSSAPI continuation error: Unspecified GSS failure.  Minor code may provide more information
GSSAPI continuation error: Server doesnotexist/cockroach@EXAMPLE.COM not found in Kerberos database
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
psql "postgresql://cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester
```
then execute the grant

```sql
GRANT ADMIN TO tester;
```

d. Finally, execute the import command with the following step

```bash
psql "postgresql://cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester -f import.sql
```

```bash
# psql "postgresql://cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester -f import.sql
DROP TABLE
       job_id       |  status   | fraction_completed | rows | index_entries | bytes
--------------------+-----------+--------------------+------+---------------+-------
 574691207820935169 | succeeded |                  1 | 1000 |          1000 | 41030
(1 row)
```

11. Connect to psql using properties

```bash
psql "host=cockroach port=26257 sslmode=verify-full user=tester krbsrvname=customspn sslrootcert=/certs/ca.crt"
```11. Connect to psql using properties
