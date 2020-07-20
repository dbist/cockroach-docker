TODO:
1. address dockerlint issues

------------------------------------------------------
1. Run `./up.sh`
2. Connect to the `psql` container using `docker exec -it psql bash`.
3. Connect to cockroach via psql with `psql "postgresql://cockroach:26257/defaultdb?sslmode=require" -U tester`

```sql
psql (9.5.22, server 9.5.0)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES128-GCM-SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=>
```
