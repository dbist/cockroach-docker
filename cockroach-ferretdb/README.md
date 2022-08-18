This is a fork of [MariaDB's NoSQL Listener example](https://github.com/mariadb-corporation/dev-example-nosql-listener)
that replaces MariaDB MaxScale and MariaDB Community Server with
[FerretDB](https://github.com/FerretDB/FerretDB) and PostgreSQL.

# Quickstart

```
$ git clone https://github.com/FerretDB/example.git

$ cd example
```

Then open [http://localhost:8888/](http://localhost:8888/) and use that example application.

If you have a recent enough `mongosh`, you can use to connect to FerretDB. For example:
[![asciicast](https://asciinema.org/a/BhBD85JpeLPHrSdyL1jzNFkFq.svg)](https://asciinema.org/a/BhBD85JpeLPHrSdyL1jzNFkFq)
You can see data in PostgreSQL using `psql`. For example:
[![asciicast](https://asciinema.org/a/RgCtFAxvkkp26YRBO6FPSpEUJ.svg)](https://asciinema.org/a/RgCtFAxvkkp26YRBO6FPSpEUJ)


# FerretDB with Cockroach

Uses [MangoDB](https://github.com/MangoDB-io/MangoDB) API

```bash
./up.sh
```

## Once up, connect to mongosh

```bash
docker exec -it mongosh mongosh mongodb://ferretdb/
```

```bash
Current Mongosh Log ID: 62fe3e43d1d4d65b64a89a8e
Connecting to:          mongodb://ferretdb/?directConnection=true&appName=mongosh+1.5.4
Using MongoDB:          5.0.42
Using Mongosh:          1.5.4

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2022-08-18T13:27:32.063Z: Powered by 🥭 FerretDB v0.5.2 and PostgreSQL 13.0.0.
   2022-08-18T13:27:32.063Z: Please star us on GitHub: https://github.com/FerretDB/FerretDB
------

test>
```

```bash
test> db.test.insert({name: "Ada Lovelace", age: 205})
DeprecationWarning: Collection.insert() is deprecated. Use insertOne, insertMany, or bulkWrite.
{
  acknowledged: true,
  insertedIds: { '0': ObjectId("62fe3e9b767e5e1adb00a7dc") }
}
```


```bash
test> db.inventory.insertMany( [
...    { item: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
...    { item: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "P" },
...    { item: "paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D" },
...    { item: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D" },
...    { item: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A" },
... ] );
```

```bash
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId("62fe3fca767e5e1adb00a7dd"),
    '1': ObjectId("62fe3fca767e5e1adb00a7de"),
    '2': ObjectId("62fe3fca767e5e1adb00a7df"),
    '3': ObjectId("62fe3fca767e5e1adb00a7e0"),
    '4': ObjectId("62fe3fca767e5e1adb00a7e1")
  }
}
```

## This is where it used to break

```bash
test> db.test.insert({name: "Ada Lovelace", age: 205})
DeprecationWarning: Collection.insert() is deprecated. Use insertOne, insertMany, or bulkWrite.
Uncaught:
MongoBulkWriteError: connection 3 to 172.23.0.4:27017 closed
Result: BulkWriteResult {
  result: {
    ok: 1,
    writeErrors: [],
    writeConcernErrors: [],
    insertedIds: [ { index: 0, _id: ObjectId("6182e88d9e28440843d37de8") } ],
    nInserted: 0,
    nUpserted: 0,
    nMatched: 0,
    nModified: 0,
    nRemoved: 0,
    upserted: []
  }
}
test>
