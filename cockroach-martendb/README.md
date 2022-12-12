# Sample 3 node *insecure* CockroachDB cluster with HAProxy acting as load balancer and a sample [EventSourcingIntro](https://github.com/JasperFx/marten/tree/master/src/samples/EventSourcingIntro) application using [MartenDB](https://martendb.io/introduction.html)

Prerequisites:

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `pgbouncer` - Lightweight connection pooling utility
* `client` - client machine containing `cockroach` binary
* `app` - dotnet application

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1. Start the tutorial using `./up.sh` script

```bash
Creating network "cockroach-pgbouncer_default" with the default driver
Creating roach-0 ... done
Creating roach-1 ... done
Creating roach-2 ... done
Creating lb      ... done
Creating pgbouncer ... done
Creating client    ... done
Cluster successfully initialized
CREATE ROLE

Time: 9ms

GRANT

Time: 87ms
```

2. visit the [HAProxy UI](http://localhost:8081)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti client /bin/bash

# cli inside the container
cockroach sql --insecure --host=lb

# directly
docker exec -ti client cockroach sql --insecure --host=lb
```

3. Inspect the app

```bash
docker logs app
```



## WIP

```bash
---> Npgsql.PostgresException (0x80004005): 0A000: at or near "language": syntax error: unimplemented: this syntax

DETAIL: source SQL:
CREATE OR REPLACE FUNCTION public.mt_grams_vector(text)
        RETURNS tsvector
        LANGUAGE plpgsql
        ^
   at Npgsql.Internal.NpgsqlConnector.<ReadMessage>g__ReadMessageLong|213_0(NpgsqlConnector connector, Boolean async, DataRowLoadingMode dataRowLoadingMode, Boolean readingNotifications, Boolean isReadingPrependedMessage)
   at Npgsql.NpgsqlDataReader.NextResult(Boolean async, Boolean isConsuming, CancellationToken cancellationToken)
   at Npgsql.NpgsqlCommand.ExecuteReader(CommandBehavior behavior, Boolean async, CancellationToken cancellationToken)
   at Npgsql.NpgsqlCommand.ExecuteReader(CommandBehavior behavior, Boolean async, CancellationToken cancellationToken)
   at Npgsql.NpgsqlCommand.ExecuteNonQuery(Boolean async, CancellationToken cancellationToken)
   at Weasel.Postgresql.PostgresqlMigrator.executeDelta(SchemaMigration migration, DbConnection conn, AutoCreate autoCreate, IMigrationLogger logger)
  Exception data:
    Severity: ERROR
    SqlState: 0A000
    MessageText: at or near "language": syntax error: unimplemented: this syntax
    Detail: source SQL:
CREATE OR REPLACE FUNCTION public.mt_grams_vector(text)
        RETURNS tsvector
        LANGUAGE plpgsql
        ^
    Hint: You have attempted to use a feature that is not yet implemented.
See: https://go.crdb.dev/issue-v/7821/v22.2
    File: lexer.go
    Line: 242
    Routine: UnimplementedWithIssueDetail
   --- End of inner exception stack trace ---
   at Marten.StoreOptions.Weasel.Core.Migrations.IMigrationLogger.OnFailure(DbCommand command, Exception ex)
   at Weasel.Postgresql.PostgresqlMigrator.executeDelta(SchemaMigration migration, DbConnection conn, AutoCreate autoCreate, IMigrationLogger logger)
   at Weasel.Core.Migrator.ApplyAll(DbConnection conn, SchemaMigration migration, AutoCreate autoCreate, IMigrationLogger logger)
   at Weasel.Core.Migrations.DatabaseBase`1.executeMigration(ISchemaObject[] schemaObjects, CancellationToken token)
   at Weasel.Core.Migrations.DatabaseBase`1.executeMigration(ISchemaObject[] schemaObjects, CancellationToken token)
   at Weasel.Core.Migrations.DatabaseBase`1.generateOrUpdateFeature(Type featureType, IFeatureSchema feature, CancellationToken token)
   at Weasel.Core.Migrations.DatabaseBase`1.ensureStorageExists(IList`1 types, Type featureType, CancellationToken token)
   at Weasel.Core.Migrations.DatabaseBase`1.ensureStorageExists(IList`1 types, Type featureType, CancellationToken token)
   at Weasel.Core.Migrations.DatabaseBase`1.EnsureStorageExists(Type featureType)
   at Marten.Storage.MartenDatabase.Marten.Storage.IMartenDatabase.EnsureStorageExists(Type documentType)
   at Marten.Linq.MartenLinqQueryProvider.ensureStorageExists(LinqHandlerBuilder builder)
   at Marten.Linq.MartenLinqQueryProvider.Execute[TResult](Expression expression)
   at WarehouseRepository.Get(Guid id) in /app/Program.cs:line 60
   at Program.<Main>$(String[] args) in /app/Program.cs:line 18
```
