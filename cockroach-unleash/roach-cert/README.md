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