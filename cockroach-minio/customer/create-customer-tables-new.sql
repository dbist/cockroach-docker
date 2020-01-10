CREATE DATABASE customer;
USE customer;

IMPORT TABLE chrg_cd
(
    chrg_id UUID NOT NULL,
	cst_cntr_cd STRING NULL,
	chrg_cd_descr STRING NULL,
	automap_spl_cd STRING NULL,
	aprv_spl_cd STRING NULL,
	del_ind BOOL NOT NULL,
	CONSTRAINT "primary" PRIMARY KEY (chrg_id ASC),
	INDEX descr (chrg_cd_descr ASC),
	FAMILY "primary" (chrg_id, cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd)
) CSV DATA ('nodelocal:///chrg_cd.csv', 'nodelocal:///chrg_cd2.csv', 'nodelocal:///chrg_cd3.csv')
WITH skip = '1';

CREATE TABLE  chrg_cd_cdc (
	chrg_id UUID NOT NULL,
	cst_cntr_cd STRING NULL,
	chrg_cd_descr STRING NULL,
	automap_spl_cd STRING NULL,
	aprv_spl_cd STRING NULL,
	del_ind BOOL NOT NULL,
	CONSTRAINT "primary" PRIMARY KEY (chrg_id ASC),
	INDEX descr (chrg_cd_descr ASC),
	FAMILY "primary" (chrg_id, cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind)
);

-- track update
UPDATE chrg_cd SET del_ind = false WHERE chrg_id = '001f9c3b-f68c-4010-ac4f-cb3ad2dc979a';

-- deletes are not tracked as of now, need to add logic to NiFI flow.
DELETE FROM chrg_cd WHERE chrg_id = '00ac5e30-083c-442e-b89c-356831516cef';

-- run parser.py

-- fac_chrg
IMPORT TABLE fac_chrg
(
    fac_id INT8 NOT NULL,
    eff_dt DATE NOT NULL,
    chrg_cd STRING NOT NULL,
    chrg_id UUID NOT NULL,
	CONSTRAINT "primary" PRIMARY KEY (fac_id ASC, chrg_cd ASC, eff_dt ASC),
	INDEX fac_chrg_chrg_id_idx (chrg_id ASC)
) CSV DATA ('nodelocal:///fac_chrg.csv')
WITH skip = '1';

UPDATE fac_chrg SET chrg_id = 'da75cdc5-82aa-4a14-ad21-64d30fe58ada' WHERE fac_id = 1;
UPDATE fac_chrg SET chrg_id = 'b1b5ab75-2d27-4372-b00f-ce5efd7d42cb' WHERE fac_id = 5;
UPDATE fac_chrg SET chrg_id = 'aafe3963-ed7d-4d82-80db-c9dabea8c125' WHERE fac_id = 60;
UPDATE fac_chrg SET chrg_id = '434b7cdb-96d5-4b23-bc6e-1e94ef7d1a42' WHERE fac_id = 888;
UPDATE fac_chrg SET chrg_id = 'c2e557ad-4eed-4605-adea-3ed2928eadeb' WHERE fac_id = 999;
UPDATE fac_chrg SET chrg_id = '4f7b1dae-61cb-4b40-aa95-4bb5ca44d477' WHERE fac_id = 663;
UPDATE fac_chrg SET chrg_id = '04bc3703-cb6c-425e-9fa4-4055a4660d52' WHERE fac_id = 235;
UPDATE fac_chrg SET chrg_id = 'b7ac0907-e910-4c1e-8033-bb335c753f09' WHERE fac_id = 465;
UPDATE fac_chrg SET chrg_id = 'cbd952cf-0c18-460d-9352-97c21162f47a' WHERE fac_id = 643;
UPDATE fac_chrg SET chrg_id = '1a137f8d-d84b-4c1f-a629-71cd5a1490c9' WHERE fac_id = 123;
UPDATE fac_chrg SET chrg_id = 'a183768c-c6e4-4e35-927f-298014de29d9' WHERE fac_id = 452;
UPDATE fac_chrg SET chrg_id = 'b831fc6d-79c8-4abb-b6a1-0834ba5659b0' WHERE fac_id = 55;
UPDATE fac_chrg SET chrg_id = 'cb171c02-62c6-4bce-a0a2-f6faa9b67c11' WHERE fac_id = 884;
UPDATE fac_chrg SET chrg_id = 'b7ac0907-e910-4c1e-8033-bb335c753f09' WHERE fac_id = 441;
UPDATE fac_chrg SET chrg_id = '461cc8f7-13ee-4e58-bc3e-14ce2e0c155c' WHERE fac_id = 743;
UPDATE fac_chrg SET chrg_id = '8e2fe059-eccf-4462-835e-9a95503e11a2' WHERE fac_id = 234;
UPDATE fac_chrg SET chrg_id = 'e8eb1639-89e0-4c02-9dc7-f91b64681537' WHERE fac_id = 753;
UPDATE fac_chrg SET chrg_id = '91e9fe5d-6f74-4ecd-8126-2da16fc6216d' WHERE fac_id = 546;
UPDATE fac_chrg SET chrg_id = 'f32be81d-e356-48bf-aa9f-74f540fb1a12' WHERE fac_id = 214;
UPDATE fac_chrg SET chrg_id = 'ec84629d-4d1f-4f7a-813a-f626428443b3' WHERE fac_id = 75;
UPDATE fac_chrg SET chrg_id = 'c984db80-1d6e-4186-909d-9b380abc93c0' WHERE fac_id = 753;
UPDATE fac_chrg SET chrg_id = '07d9811f-7915-4e0c-974f-0d74037d1ad3' WHERE fac_id = 875;
UPDATE fac_chrg SET chrg_id = 'c984db80-1d6e-4186-909d-9b380abc93c0' WHERE fac_id = 701;
UPDATE fac_chrg SET chrg_id = 'cb171c02-62c6-4bce-a0a2-f6faa9b67c11' WHERE fac_id = 885;

CREATE TABLE spl (
    spl_cd STRING NOT NULL,
    CONSTRAINT "primary" PRIMARY KEY (spl_cd ASC),
    FAMILY "primary" (spl_cd)
);

UPSERT INTO spl (spl_cd) SELECT DISTINCT automap_spl_cd FROM chrg_cd LIMIT 100000;
UPSERT INTO spl (spl_cd) SELECT DISTINCT aprv_spl_cd FROM chrg_cd LIMIT 100000;




-- Enable Enterprise License

SET CLUSTER SETTING kv.rangefeed.enabled = true;

SET DATABASE = customer;

CREATE CHANGEFEED FOR TABLE chrg_cd, fac_chrg, spl INTO 'experimental-s3://miniobucket/customer/materialized?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=http://minio:9000&AWS_REGION=us-east-1' with updated;


CREATE TABLE  materialized_table (
	chrg_id UUID,
	cst_cntr_cd STRING NULL,
	chrg_cd_descr STRING NULL,
	automap_spl_cd STRING NULL,
	aprv_spl_cd STRING NULL,
	del_ind BOOL default false,
    fac_id INT8,
	eff_dt DATE,
	chrg_cd STRING,
    chrg_id_fac UUID,
    spl_cd STRING
);



--------------
CREATE TABLE  materialized_table (
	chrg_id UUID,
	cst_cntr_cd STRING NULL,
	chrg_cd_descr STRING NULL,
	automap_spl_cd STRING NULL,
	aprv_spl_cd STRING NULL,
	del_ind BOOL default false,
    fac_id INT8,
	eff_dt DATE,
	chrg_cd STRING,
    chrg_id_fac UUID,
	spl_cd1 STRING,
    spl_cd2 STRING
);

UPSERT INTO customer.materialized_table 
SELECT c.*, f.*, sp1.*, sp2.* FROM 
chrg_cd c
        JOIN fac_chrg f
             ON f.chrg_id = c.chrg_id
            LEFT JOIN spl AS sp1 ON c.automap_spl_cd = sp1.spl_cd 
	    LEFT JOIN spl AS sp2 ON c.aprv_spl_cd = sp2.spl_cd;


        -- should match materialized table??
SELECT count(*) FROM 
chrg_cd c
        JOIN fac_chrg f
             ON f.chrg_id = c.chrg_id
            LEFT JOIN spl AS sp1 ON c.automap_spl_cd = sp1.spl_cd 
	    LEFT JOIN spl AS sp2 ON c.aprv_spl_cd = sp2.spl_cd;


----------------


-- copy files to docker container
docker cp chrg_cd.sql crdb-1:/
docker cp fac_chrg.sql crdb-1:/
docker cp spl.sql crdb-1:/

--login to container
docker exec -it crdb-1 bash
--upsert
cat /spl.sql | ./cockroach sql --insecure --database=customer
cat /fac_chrg.sql | ./cockroach sql --insecure --database=customer
cat /chrg_cd.sql | ./cockroach sql --insecure --database=customer



CREATE USER IF NOT EXISTS maxroach;
GRANT ALL ON DATABASE customer TO maxroach;

