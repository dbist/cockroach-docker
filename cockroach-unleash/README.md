# CockroachDB with unleash
---

## Start project

```bash
./up.sh
```

## After compose project is up, check the unleash logs

```bash
docker logs unleash
```

```bash
[2022-01-06T20:43:18.237] [ERROR] server-impl.js - Failed to migrate db error: column "strategies" does not exist
    at Parser.parseErrorMessage (/unleash/node_modules/pg-protocol/dist/parser.js:287:98)
    at Parser.handlePacket (/unleash/node_modules/pg-protocol/dist/parser.js:126:29)
    at Parser.parse (/unleash/node_modules/pg-protocol/dist/parser.js:39:38)
    at Socket.<anonymous> (/unleash/node_modules/pg-protocol/dist/index.js:11:42)
    at Socket.emit (events.js:400:28)
    at addChunk (internal/streams/readable.js:293:12)
    at readableAddChunk (internal/streams/readable.js:267:9)
    at Socket.Readable.push (internal/streams/readable.js:206:10)
    at TCP.onStreamRead (internal/stream_base_commons.js:188:23) {
  length: 105,
  severity: 'ERROR',
  code: '42703',
  detail: undefined,
  hint: undefined,
  position: undefined,
  internalPosition: undefined,
  internalQuery: undefined,
  where: undefined,
  schema: undefined,
  table: undefined,
  column: undefined,
  dataType: undefined,
  constraint: undefined,
  file: 'column_resolver.go',
  line: '196',
  routine: 'NewUndefinedColumnError'
}
[ERROR] error: column "strategies" does not exist
    at Parser.parseErrorMessage (/unleash/node_modules/pg-protocol/dist/parser.js:287:98)
    at Parser.handlePacket (/unleash/node_modules/pg-protocol/dist/parser.js:126:29)
    at Parser.parse (/unleash/node_modules/pg-protocol/dist/parser.js:39:38)
    at Socket.<anonymous> (/unleash/node_modules/pg-protocol/dist/index.js:11:42)
    at Socket.emit (events.js:400:28)
    at addChunk (internal/streams/readable.js:293:12)
    at readableAddChunk (internal/streams/readable.js:267:9)
    at Socket.Readable.push (internal/streams/readable.js:206:10)
    at TCP.onStreamRead (internal/stream_base_commons.js:188:23)
➜  cockroach-unleash git:(main) 
```

Filed with Unleash folks [#1240](https://github.com/Unleash/unleash/issues/1240)


1/10/22

spun up a PG container and as per Unleash support will attempt to initalize Unleash first with PG, then migrate the database to Cockroach

From the host:

```bash
psql "postgresql://localhost:5432/unleash?sslmode=disable" -U unleash_user
```

```sql
psql (14.1)
Type "help" for help.

unleash=# \dt
                  List of relations
 Schema |         Name         | Type  |    Owner     
--------+----------------------+-------+--------------
 public | addons               | table | unleash_user
 public | api_tokens           | table | unleash_user
 public | client_applications  | table | unleash_user
 public | client_instances     | table | unleash_user
 public | client_metrics_env   | table | unleash_user
 public | context_fields       | table | unleash_user
 public | environments         | table | unleash_user
 public | events               | table | unleash_user
 public | feature_environments | table | unleash_user
 public | feature_strategies   | table | unleash_user
 public | feature_tag          | table | unleash_user
 public | feature_types        | table | unleash_user
 public | features             | table | unleash_user
 public | migrations           | table | unleash_user
 public | project_environments | table | unleash_user
 public | projects             | table | unleash_user
 public | reset_tokens         | table | unleash_user
 public | role_permission      | table | unleash_user
 public | role_user            | table | unleash_user
 public | roles                | table | unleash_user
 public | settings             | table | unleash_user
 public | strategies           | table | unleash_user
 public | tag_types            | table | unleash_user
 public | tags                 | table | unleash_user
 public | unleash_session      | table | unleash_user
 public | user_feedback        | table | unleash_user
 public | user_splash          | table | unleash_user
 public | users                | table | unleash_user
```

```bash
docker exec -it pg bash
```

## Dump the database

```bash
pg_dump unleash > /tmp/unleash.sql -U unleash_user
```

## Copy the backup to host and then to one of the nodes

```bash
docker cp pg:/tmp/unleash.sql
docker cp unleash.sql roach-0:/tmp/
```

## Upload the file to CockroachDB userfile

```bash
./cockroach userfile upload /tmp/unleash.sql  --insecure --host=lb
```

## Restore the database

```sql
root@lb:26257/defaultdb> import pgdump 'userfile://defaultdb.public.userfiles_root/unleash.sql' WITH ignore_unsupported_stateme
nts;
ERROR: referenced table "public.events_id_seq" not found in tables being imported (public.feature_types,public.projects)
```

```sql
root@lb:26257/unleash> CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
invalid syntax: statement ignored: at or near "start": syntax error: unimplemented: this syntax
SQLSTATE: 0A000
DETAIL: source SQL:
CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    ^
HINT: You have attempted to use a feature that is not yet implemented.
See: https://go.crdb.dev/issue-v/25110/v21.2
```

## Workaround

```sql
CREATE SEQUENCE public.events_id_seq
    --AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
```

the `AS integer` syntax will be supported in 22.1, every sequence in this dump needs to be commented out

Create sequences manually

CREATE SEQUENCE public.addons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE public.migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
   
CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


After creating the sequences manually, import still breaks on

```sql
ERROR: referenced table "public.migrations_id_seq" not found in tables being imported (public.tag_types,public.unleash_session,public.client_instances,public.projects)
```

Engineering is looking.