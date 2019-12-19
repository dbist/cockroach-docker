-- set license and organization

SET CLUSTER SETTING kv.rangefeed.enabled = true;

CREATE DATABASE cdc_demo;

SET DATABASE = cdc_demo;

CREATE TABLE office_dogs (
     id INT PRIMARY KEY,
     name STRING);

INSERT INTO office_dogs VALUES
   (1, 'Petee'),
   (2, 'Carl');

UPDATE office_dogs SET name = 'Petee H' WHERE id = 1;

CREATE CHANGEFEED FOR TABLE office_dogs INTO 'experimental-s3://miniobucket/dogs?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=http://minio:9000&AWS_REGION=us-east-1' with updated, resolved='10s';
