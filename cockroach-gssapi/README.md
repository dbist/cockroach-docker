TODO:
1. figure out how to programmatically update the /etc/hosts file, specifically on the psql machine for `kdc`, `psql` and `cockroach`

# Sample hosts file, the `cockroach` IP seems to always be #.#.#.n-1

```
192.168.240.5	psql
192.168.240.4   cockroach
```

# Connect to psql

```bash
docker exec -it psql bash
```

# Connect to cockroach

```sql
psql "postgresql://cockroach:26257/defaultdb?sslmode=require" -U tester
```

```sql
psql (9.5.22, server 9.5.0)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES128-GCM-SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=>
```
