# Sample CockroachDB application using CockroachDB, MIT Kerberos and native `cockroach` GSSAPI client authentication
---
Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)

---
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

8. If for any reason you'd like to re-authenticate with Kerberos, using a container where `krb5-user` libraries are installed and `krb5.conf` is configured using tester user password [[psql]]:

```bash
kdestroy -A
kinit tester
```

9. Using `krbsrvname` to override `postgres` SPN (service principal name) requires a new entry in Kerberos and the associated keytab

```bash
kadmin.local -q "addprinc -randkey customspn/cockroach@EXAMPLE.COM
kadmin.local -q "ktadd -k /keytab/crdb.keytab customspn/cockroach@EXAMPLE.COM"
```

10. Confirm we have Kerberos enabled

If you're unconvinced that Kerberos is on, let's try to check the `host_based_authentication.configuration` property
Because we're logged in as tester and tester is not an `admin`, we need to login with `root`.

```sql
tester@cockroach:26257/defaultdb> SHOW CLUSTER SETTING server.host_based_authentication.configuration;
ERROR: only users with the admin role are allowed to SHOW CLUSTER SETTING
SQLSTATE: 42501
tester@cockroach:26257/defaultdb> \q
ERROR: only users with the admin role are allowed to SHOW CLUSTER SETTING
SQLSTATE: 42501
Failed running "sql"
root@client:/cockroach# cockroach sql --certs-dir=/certs --host=cockroach
#
# Welcome to the CockroachDB SQL shell.
# All statements must be terminated by a semicolon.
# To exit, type: \q.
#
# Client version: CockroachDB CCL v20.2.0-alpha.1-1529-g069d328c2d-dirty (x86_64-unknown-linux-gnu, built 2020/07/27 16:49:42, go1.14.4)
# Server version: CockroachDB CCL v20.1.3 (x86_64-unknown-linux-gnu, built 2020/06/23 08:44:08, go1.13.9)

warning: server version older than client! proceed with caution; some features may not be available.

# Cluster ID: edbd8291-4432-4897-a4e4-af49cdbfdfed
# Organization: Cockroach Labs - Production Testing
#
# Enter \? for a brief introduction.
#
root@cockroach:26257/defaultdb> SHOW CLUSTER SETTING server.host_based_authentication.configuration;
  server.host_based_authentication.configuration
--------------------------------------------------
  host all all all gss include_realm=0
(1 row)

Time: 1.0508ms
```

11. Using custom spn without `krbsrvname`

```bash
cockroach sql --certs-dir=/certs --url "postgresql://tester:nopassword@cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&spn=customspn/cockroach"
```

or

```bash
cockroach sql --certs-dir=/certs --url "postgresql://tester:nopassword@cockroach:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&service=customspn
```
