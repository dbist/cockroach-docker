# jOOQ and CockroachDB [tutorial](https://www.cockroachlabs.com/docs/stable/build-a-java-app-with-cockroachdb-jooq)

#### This is work in progress

you must start the instance using

```bash
docker compose -f docker-compose.yml -f docker-compose-jooq.yml up -d --build
```

then login into the jooq container and run the package manually

```bash
docker exec -it jooq bash
```

```bash
mvn exec:java -Dexec.mainClass=com.cockroachlabs.Sample
```

you can also combine both steps into one

```bash
docker exec -it jooq mvn exec:java -Dexec.mainClass=com.cockroachlabs.Sample
```
