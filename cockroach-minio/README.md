### This is a tutorial based on a single node CockroachDB cluster and Minio cloud storage sink for [changefeed](https://www.cockroachlabs.com/docs/stable/change-data-capture.html#create-a-changefeed-connected-to-a-cloud-storage-sink). As of 19.2.2 configurable changefeeds require an enterprise license of CockroachDB.

 - [CockroachDB](https://www.cockroachlabs.com/docs/stable/enterprise-licensing.html)
 - [Minio](https://hub.docker.com/r/minio/minio/)

https://docs.min.io/docs/aws-cli-with-minio
https://www.cockroachlabs.com/docs/v19.2/backup.html#backup-file-urls under S3-compatible services

# Create Minio bucket, in my case `miniobucket`

```sql
CREATE CHANGEFEED FOR TABLE office_dogs INTO 'experimental-s3://miniobucket/dogs?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=http://minio:9000' with updated, resolved='10s';
```

```bash
root@:26257/cdc_demo> CREATE CHANGEFEED FOR TABLE office_dogs INTO 'experimental-s3://miniobucket/dogs?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=http://minio:9000' with updated, resolved='10s';
        job_id
+--------------------+
  513248960812449793
(1 row)

Time: 16.1918ms
```

now browse to the minio bucket directory and look for dogs directory, navigate to the /miniobucket/dogsdir/2019-12-18/ and you will find a bunch of *.RESOLVED and a JSON file. JSON file will contain all of the updates.

```
{"after": {"id": 1, "name": "Pete!"}, "key": [1], "updated": "1576701552590477800.0000000000"}
{"after": {"id": 2, "name": "Carl"}, "key": [2], "updated": "1576701552590477800.0000000000"}
201912182039125904778000000000000-a811836c424bb311-1-324-00000000-office_dogs-1.ndjson (END)
```
if you issue another `UPDATE` statement, changefeed will create another JSON file.

```sql
UPDATE office_dogs SET name = 'Pete H' WHERE id = 1;
UPDATE office_dogs SET name = 'Baethoven' WHERE id = 1;
```

```bash
201912182130162087013000000000000-e74c329c6545f502-1-2-00000000-office_dogs-1.ndjson
201912182130162087013000000000000.RESOLVED
201912182130162087013000000000001-e74c329c6545f502-1-2-00000001-office_dogs-1.ndjson
201912182130297139841000000000000.RESOLVED
201912182130416808740000000000000.RESOLVED
201912182130536816253000000000000.RESOLVED
201912182130536816253000000000001-e74c329c6545f502-1-2-00000002-office_dogs-1.ndjson
201912182131056829854000000000000.RESOLVED
```

### View the `.ndjson` files for all the changes

```bash
head  *.ndjson
==> 201912182130162087013000000000000-e74c329c6545f502-1-2-00000000-office_dogs-1.ndjson <==
{"after": {"id": 1, "name": "Petee H"}, "key": [1], "updated": "1576704616208701300.0000000000"}
{"after": {"id": 2, "name": "Carl"}, "key": [2], "updated": "1576704616208701300.0000000000"}

==> 201912182130162087013000000000001-e74c329c6545f502-1-2-00000001-office_dogs-1.ndjson <==
{"after": {"id": 1, "name": "Pete H"}, "key": [1], "updated": "1576704627177722800.0000000000"}

==> 201912182130536816253000000000001-e74c329c6545f502-1-2-00000002-office_dogs-1.ndjson <==
{"after": {"id": 1, "name": "Baethoven"}, "key": [1], "updated": "1576704694317030100.0000000000"}
```
docker cp postgresql-42.2.9.jar cockroach-minio_nifi_1:/opt/nifi/nifi-current/extensions/
