### This is a tutorial based on a single node CockroachDB cluster and Minio cloud storage sink for [changefeed](https://www.cockroachlabs.com/docs/stable/change-data-capture.html#create-a-changefeed-connected-to-a-cloud-storage-sink). As of 19.2.2 configurable changefeeds require an enterprise license of CockroachDB.

 - [CockroachDB](https://www.cockroachlabs.com/docs/stable/enterprise-licensing.html)
 - [Minio](https://hub.docker.com/r/minio/minio/)


```sql
CREATE CHANGEFEED FOR TABLE office_dogs INTO 'experimental-s3://miniobucket:/test?MINIO_ACCESS_KEY=miniominio&MINIO_SECRET_KEY=miniominio13' with updated, resolved='10s';
```

CREATE CHANGEFEED FOR TABLE office_dogs INTO 'experimental-s3://example-bucket-name/test?AWS_ACCESS_KEY_ID=enter_key-here&AWS_SECRET_ACCESS_KEY=enter_key_here' with updated, resolved='10s';
