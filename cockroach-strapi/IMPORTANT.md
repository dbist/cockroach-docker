requires at the minimum 20.1 as SAVEPOINTS are needed in CRDB

https://github.com/knex/knex/issues/2002
https://github.com/cockroachdb/cockroach/issues/15299

as of 2017 comments on the issue, the following were not supported, need to test with 20.1

```
select * for update is not supported by cockroach
column name "current_schema" not found b/c current_schema is not enclosed in ' '
migrations lock does not work
uuid and json types are not supported
.primary() in migrations fails with something like "multiple primary keys not allowed";
```
