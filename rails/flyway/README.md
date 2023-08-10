# Flyway
---

## Raw call

```bash
docker run \
    --rm \
    --network cockroach-docker_default \
    -v $PWD/flyway/sql:/flyway/sql \
    flyway/flyway \
    -url=jdbc:postgresql://lb:26000/defaultdb \
    -user=root \
    -password= \
    -connectRetries=3 \
    info
```

## Using config file

```bash
docker run \
    --rm \
    --network cockroach-docker_default \
    -v $PWD/flyway/sql:/flyway/sql \
    -v $PWD/flyway/conf:/flyway/conf \
    flyway/flyway \
    info
```

```bash
Flyway is up to date
Flyway Community Edition 9.11.0 by Redgate
See what's new here: https://flywaydb.org/documentation/learnmore/releaseNotes#9.11.0

Database: jdbc:postgresql://lb:26000/defaultdb (PostgreSQL 13.0)
WARNING: Flyway upgrade recommended: CockroachDB 22.2 is newer than this version of Flyway and support has not been tested. The latest supported version of CockroachDB is 22.1.
Schema version: << Empty Schema >>

+-----------+---------+-----------------+------+--------------+---------+----------+
| Category  | Version | Description     | Type | Installed On | State   | Undoable |
+-----------+---------+-----------------+------+--------------+---------+----------+
| Versioned | 1       | Create database | SQL  |              | Pending | No       |
+-----------+---------+-----------------+------+--------------+---------+----------+
```

## Run a migration

```bash
docker run \
    --rm \
    --network cockroach-docker_default \
    -v $PWD/flyway/sql:/flyway/sql \
    -v $PWD/flyway/conf:/flyway/conf \
    flyway/flyway \
    migrate
```

```bash
Flyway is up to date
Flyway Community Edition 9.11.0 by Redgate
See what's new here: https://flywaydb.org/documentation/learnmore/releaseNotes#9.11.0

Database: jdbc:postgresql://lb:26000/defaultdb (PostgreSQL 13.0)
WARNING: Flyway upgrade recommended: CockroachDB 22.2 is newer than this version of Flyway and support has not been tested. The latest supported version of CockroachDB is 22.1.
Successfully validated 1 migration (execution time 00:00.015s)
Creating Schema History table "public"."flyway_schema_history" ...
Current version of schema "public": << Empty Schema >>
Migrating schema "public" to version "1 - Create database" [non-transactional]
Successfully applied 1 migration to schema "public", now at version v1 (execution time 00:00.100s)
```

## Running info again

```bash
Flyway is up to date
Flyway Community Edition 9.11.0 by Redgate
See what's new here: https://flywaydb.org/documentation/learnmore/releaseNotes#9.11.0

Database: jdbc:postgresql://lb:26000/defaultdb (PostgreSQL 13.0)
WARNING: Flyway upgrade recommended: CockroachDB 22.2 is newer than this version of Flyway and support has not been tested. The latest supported version of CockroachDB is 22.1.
Schema version: 1

+-----------+---------+-----------------+------+---------------------+---------+----------+
| Category  | Version | Description     | Type | Installed On        | State   | Undoable |
+-----------+---------+-----------------+------+---------------------+---------+----------+
| Versioned | 1       | Create database | SQL  | 2023-01-10 18:21:54 | Success | No       |
+-----------+---------+-----------------+------+---------------------+---------+----------+
```


## Using SSL

flyway.url=jdbc:postgresql://lb:26000/defaultdb?sslcert=%2Fcerts%2Fclient.root.crt&sslkey=%2Fcerts%2Fclient.root.key.pk8&sslmode=verify-full&sslrootcert=%2Fcerts%2Fca.crt
flyway.user=root
flyway.password=""
flyway.connectRetries=3

make sure the docker container has certs directory mounted. If you run the `info` command into a container, it won't have the certs volume mounted and will complain about a missing ca.crt. The only way to make it work is if the flyway container has the context of the existing certs directory.
