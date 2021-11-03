# MangoDB with Cockroach

Uses [MangoDB](https://github.com/MangoDB-io/MangoDB) API

```bash
./up.sh
```

## Once up, spin up a mongosh client

```bash
docker run --rm -it --network=mango_default --entrypoint=mongosh mongo:5 mongodb://mangodb/
```

```bash
Current Mongosh Log ID: 6182e8535a8385e4b5f5a90d
Connecting to:          mongodb://mangodb/?directConnection=true
Using MongoDB:          5.0.42
Using Mongosh:          1.1.0

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.
```

## This is where it breaks

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
```