CREATE DATABASE CUSTOMER;
USE CUSTOMER;

-------------------------------------------------------- chrg_cd --------------------------------------------------------

CREATE TABLE  chrg_cd (
	chrg_id UUID NOT NULL,
	cst_cntr_cd STRING NULL,
	chrg_cd_descr STRING NULL,
	automap_spl_cd STRING NULL,
	aprv_spl_cd STRING NULL,
	del_ind BOOL NOT NULL, --DEFAULT false,
	CONSTRAINT "primary" PRIMARY KEY (chrg_id ASC),
	INDEX descr (chrg_cd_descr ASC),
	FAMILY "primary" (chrg_id, cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind)
);

--INSERT INTO chrg_cd SELECT gen_random_uuid(), RANDOM()::STRING, generate_series(1,7009130)::string, RANDOM()::STRING, RANDOM()::STRING;
-- create directory extern within /cockroach-data
-- copy data to /cockroach-data/extern/

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
) CSV DATA ('nodelocal:///chrg_cd.csv')
WITH skip = '1';

----------------------------------------------------------- fac_chrg --------------------------------------------------------

CREATE TABLE fac_chrg (
	fac_id INT8 NOT NULL,
	eff_dt DATE NOT NULL,
	chrg_cd STRING NOT NULL,
    chrg_id UUID NOT NULL DEFAULT gen_random_uuid(),
	CONSTRAINT "primary" PRIMARY KEY (fac_id ASC, chrg_cd ASC, eff_dt ASC),
	INDEX fac_chrg_chrg_id_idx (chrg_id ASC)
);

--INSERT INTO fac_chrg SELECT 320000000004897 AS fac_id, NOW(), RANDOM()::STRING, * FROM (SELECT chrg_id FROM chrg_cd LIMIT 20000);
--INSERT INTO fac_chrg SELECT 320000000004898 AS fac_id, NOW(), RANDOM()::STRING, * FROM (SELECT chrg_id FROM chrg_cd LIMIT 20000);
--INSERT INTO fac_chrg SELECT 320000000004899 AS fac_id, NOW(), RANDOM()::STRING, * FROM (SELECT chrg_id FROM chrg_cd LIMIT 20000);
--INSERT INTO fac_chrg SELECT 320000000004997 AS fac_id, NOW(), RANDOM()::STRING, * FROM (SELECT chrg_id FROM chrg_cd LIMIT 20000);
--INSERT INTO fac_chrg SELECT 950000000000516 AS fac_id, NOW(), RANDOM()::STRING, * FROM (SELECT chrg_id FROM chrg_cd LIMIT 20000);
--INSERT INTO fac_chrg SELECT 320000000004897 AS fac_id, NOW(), RANDOM()::STRING, * FROM (SELECT chrg_id FROM chrg_cd LIMIT 20000);

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

-- may need more
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
-------------------------------------------------------- ems_ent_xlate --------------------------------------------------------

CREATE TABLE ems_ent_xlate (
    fac_id INT8 NOT NULL,
    CONSTRAINT "primary" PRIMARY KEY (fac_id ASC),
    FAMILY "primary" (fac_id)
);

UPSERT INTO ems_ent_xlate (fac_id) SELECT DISTINCT fac_id FROM fac_chrg;

 SELECT COUNT(*) FROM chrg_cd AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id 
	LEFT JOIN ems_ent_xlate AS ems ON f.fac_id = ems.fac_id;

-------------------------------------------------------- chrg_cd_nte --------------------------------------------------------

CREATE TABLE chrg_cd_nte (
    nte_id UUID NOT NULL,
    chrg_id UUID NOT NULL,
    CONSTRAINT "primary" PRIMARY KEY (nte_id ASC),
    INDEX chrgid (chrg_id ASC),
    FAMILY "primary" (nte_id, chrg_id)
);

UPSERT INTO chrg_cd_nte (nte_id, chrg_id) SELECT gen_random_uuid(), chrg_id FROM chrg_cd;

 SELECT count(*) FROM chrg_cd AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id 
	LEFT JOIN ems_ent_xlate AS ems ON f.fac_id = ems.fac_id 
	  LEFT JOIN (SELECT chrg_id, count(*) AS chrg_cd_nte_cnt FROM chrg_cd_nte GROUP BY chrg_id) AS nte ON chrg.chrg_id = nte.chrg_id;

-------------------------------------------------------- spl --------------------------------------------------------

CREATE TABLE spl (
    spl_cd STRING NOT NULL,
    CONSTRAINT "primary" PRIMARY KEY (spl_cd ASC),
    FAMILY "primary" (spl_cd)
);

UPSERT INTO spl (spl_cd) SELECT DISTINCT automap_spl_cd FROM chrg_cd LIMIT 100000;
UPSERT INTO spl (spl_cd) SELECT DISTINCT aprv_spl_cd FROM chrg_cd LIMIT 100000;

 SELECT count(*) FROM chrg_cd AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id 
  LEFT JOIN ems_ent_xlate AS ems ON f.fac_id = ems.fac_id 
    LEFT JOIN (SELECT chrg_id, count(*) AS chrg_cd_nte_cnt FROM chrg_cd_nte GROUP BY chrg_id) AS nte ON chrg.chrg_id = nte.chrg_id 
	  LEFT JOIN spl AS sp1 ON chrg.automap_spl_cd = sp1.spl_cd 
	    LEFT JOIN spl AS sp2 ON chrg.aprv_spl_cd = sp2.spl_cd;

-------------------------------------------------------- fac_cst_cntr --------------------------------------------------------

CREATE TABLE fac_cst_cntr (
    fac_id INT8 NOT NULL,
    cst_cntr_cd STRING NOT NULL,
    CONSTRAINT "primary" PRIMARY KEY (fac_id ASC, cst_cntr_cd ASC),
    CONSTRAINT fk_fac_id_ref_ems_ent_xlate FOREIGN KEY (fac_id) REFERENCES ems_ent_xlate(fac_id),
    FAMILY "primary" (fac_id, cst_cntr_cd)
);

--INSERT INTO fac_cst_cntr (fac_id, cst_cntr_cd) SELECT DISTINCT  FROM  LIMIT 100000;
UPSERT INTO fac_cst_cntr (fac_id, cst_cntr_cd) SELECT fac_id, cst_cntr_cd FROM chrg_cd AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id;

SELECT count(*) FROM chrg_cd AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id 
  LEFT JOIN ems_ent_xlate AS ems ON f.fac_id = ems.fac_id 
    LEFT JOIN (SELECT chrg_id, count(*) AS chrg_cd_nte_cnt FROM chrg_cd_nte GROUP BY chrg_id) AS nte ON chrg.chrg_id = nte.chrg_id 
	  LEFT JOIN spl AS sp1 ON chrg.automap_spl_cd = sp1.spl_cd 
	    LEFT JOIN spl AS sp2 ON chrg.aprv_spl_cd = sp2.spl_cd 
		  LEFT LOOKUP JOIN fac_cst_cntr AS fcc ON (fcc.cst_cntr_cd = chrg.cst_cntr_cd) AND (fcc.fac_id = f.fac_id) WHERE NOT chrg.del_ind;

------------------------------------------------------- CDC ------------------------------------------------------------------------

-- Enable Enterprise License

SET CLUSTER SETTING kv.rangefeed.enabled = true;

SET DATABASE = customer;

-- chrg_cd
CREATE CHANGEFEED FOR TABLE chrg_cd INTO 'experimental-s3://miniobucket/customer/chrg_cd?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=http://minio:9000&AWS_REGION=us-east-1' with updated;
-- Update the table with new data
UPDATE chrg_cd SET del_ind = false WHERE chrg_id = '033c04d1-e749-4602-b637-a6246489af3b';

-- create copy table from CDC

CREATE TABLE  chrg_cd_copy (
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

SELECT COUNT(*) FROM chrg_cd_copy;

-- truncate the tables, start NiFi
truncate table chrg_cd_copy;

-- run import into now // need to fix the flow to pick up imports not just updates unless NiFI restart is required?

curl "https://api.mockaroo.com/api/85584ab0?count=1000&key=a2efab40" >> "chrg_cd2.csv"

IMPORT INTO chrg_cd (chrg_id, cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind) CSV DATA ('nodelocal:///chrg_cd.csv', 'nodelocal:///chrg_cd2.csv', 'nodelocal:///chrg_cd3.csv')
WITH skip = '1';

UPDATE chrg_cd SET del_ind = false WHERE chrg_id = '00ac5e30-083c-442e-b89c-356831516cef';

-- deletes are not tracked as of now, need to add logic to NiFI flow.
DELETE FROM chrg_cd WHERE chrg_id = '00ac5e30-083c-442e-b89c-356831516cef';

--chrg_id = NULL means deleted

--insert
UPSERT INTO chrg_cd VALUES('62b3dba1-82ce-4a69-913c-232a345752ee', 'Xodol',	'Rebel Distributors Corp', 'hydrocodone bitartrate and acetaminophen', 'Re-engineered', false);
UPSERT INTO chrg_cd VALUES('892a09c2-92d4-4f99-ae15-40f456341dbb', 'Aspirin', 'KEM Pharma LLC', 'Aspirin', 'secured line', true);
UPSERT INTO chrg_cd VALUES('edbd40da-8a42-4350-a827-5908cb3921cc', 'Treatment Set TS350533', 'Antigen Laboratories, Inc.', 'Treatment Set TS350533', 'complexity', true);
UPSERT INTO chrg_cd VALUES('dd8bcc36-6f5c-4ce1-824b-b71c48483a33', 'PAXILCR', 'Physicians Total Care, Inc.	', 'paroxetine hydrochloride', 'model', false);
UPSERT INTO chrg_cd VALUES('813c40bc-46e1-4f26-87ce-18ddb58d5e44', 'Laxative Pills', 'Freds Inc', 'Sennosides', 'content-based', true);

UPDATE chrg_cd SET del_ind = true WHERE chrg_id = '62b3dba1-82ce-4a69-913c-232a345752ee';
UPSERT INTO chrg_cd VALUES('ea979a49-d764-46f8-8b07-534b223832ff',	'Coppertone Kids Sunscreen', 'MSD Consumer Care, Inc.',	'Avobenzone, Homosalate, Octisalate, Octocrylene, and Oxybenzone', 'Automated',	true);
UPSERT INTO chrg_cd VALUES('c2eaf728-8aa7-4660-83a7-032e35285ebd',	'natural extensions', 'Antibacterial Foaming Hand Wash', 'Benco Dental Company', 'Triclosan', false);
UPSERT INTO chrg_cd VALUES('bbafb23b-853e-4563-ab9f-f15fb89bf14b', 'Smart Sense Ranitidine', 'Kmart Corporation', 'Ranitidine', 'asynchronous', true);
UPSERT INTO chrg_cd VALUES('ffb01087-591b-4105-b1a3-c91da025c2dc', 'Medpride', 'Shield Line LLC', 'ZINC OXIDE DIMETHICONE', 'methodology', false);
UPSERT INTO chrg_cd VALUES('ee7be67a-93b6-42a0-bd9a-715438461cf8', 'Care One', 'Hemorrhoidal', 'American Sales Company', 'Mineral oil Petrolatum Phenylephrine HCl Shark liver oil', false);

UPSERT INTO chrg_cd VALUES('6b2a4f9b-fe06-4f56-b292-a487658edfee', 'Amitriptyline Hydrochloride', 'Qualitest Pharmaceuticals', 'Amitriptyline Hydrochloride', 'Synergistic', false);
UPSERT INTO fac_chrg VALUES('4468', '2019-01-28', 'SAC-VAL Premium Clear Antiseptic Hand Wash', '6b2a4f9b-fe06-4f56-b292-a487658edfee');
UPSERT INTO ems_ent_xlate VALUES('4468');
UPSERT INTO chrg_cd_nte VALUES('5fe7a91e-29a9-4209-9843-1abbb8c548ee', '6b2a4f9b-fe06-4f56-b292-a487658edfee');

UPSERT INTO 

UPSERT INTO chrg_cd VALUES();


UPDATE chrg_cd SET del_ind = true WHERE chrg_id = '892a09c2-92d4-4f99-ae15-40f456341dbb';
UPDATE chrg_cd SET del_ind = true WHERE chrg_id = 'edbd40da-8a42-4350-a827-5908cb3921cc';
UPDATE chrg_cd SET del_ind = false WHERE chrg_id = 'dd8bcc36-6f5c-4ce1-824b-b71c48483a33';
UPDATE chrg_cd SET del_ind = true WHERE chrg_id = '813c40bc-46e1-4f26-87ce-18ddb58d5e44';

---- multiple table changefeed

CREATE CHANGEFEED FOR TABLE fac_chrg, ems_ent_xlate, chrg_cd_nte, spl, fac_cst_cntr INTO 'experimental-s3://miniobucket/customer/materialized?AWS_ACCESS_KEY_ID=miniominio&AWS_SECRET_ACCESS_KEY=miniominio13&AWS_ENDPOINT=http://minio:9000&AWS_REGION=us-east-1' with updated;


CREATE TABLE  materialized_table (
	chrg_id UUID NOT NULL,
	cst_cntr_cd STRING NULL,
	chrg_cd_descr STRING NULL,
	automap_spl_cd STRING NULL,
	aprv_spl_cd STRING NULL,
	del_ind BOOL NOT NULL,
	spl_cd STRING NOT NULL,
	fac_id INT8 NOT NULL,
	eff_dt DATE NOT NULL,
	chrg_cd STRING NOT NULL
);

UPSERT INTO materialized_table 
SELECT chrg.chrg_id, chrg.cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind, sp1.spl_cd, f.fac_id, eff_dt, chrg_cd FROM chrg_cd AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id 
  LEFT JOIN ems_ent_xlate AS ems ON f.fac_id = ems.fac_id 
    LEFT JOIN (SELECT chrg_id, count(*) AS chrg_cd_nte_cnt FROM chrg_cd_nte GROUP BY chrg_id) AS nte ON chrg.chrg_id = nte.chrg_id 
	  LEFT JOIN spl AS sp1 ON chrg.automap_spl_cd = sp1.spl_cd 
	    LEFT JOIN spl AS sp2 ON chrg.aprv_spl_cd = sp2.spl_cd 
		  LEFT LOOKUP JOIN fac_cst_cntr AS fcc ON (fcc.cst_cntr_cd = chrg.cst_cntr_cd) AND (fcc.fac_id = f.fac_id) WHERE NOT chrg.del_ind;



0. truncate table chrg_cd;
1. CREATE CHANGEFEED chrg_cd
2. UPSERT SOME DATA
3. START NiFI



-- chrg_cd_copy
SELECT chrg.chrg_id, chrg.cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind, sp1.spl_cd, f.fac_id, eff_dt, chrg_cd FROM chrg_cd_copy AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id 
  LEFT JOIN ems_ent_xlate AS ems ON f.fac_id = ems.fac_id 
    LEFT JOIN (SELECT chrg_id, count(*) AS chrg_cd_nte_cnt FROM chrg_cd_nte GROUP BY chrg_id) AS nte ON chrg.chrg_id = nte.chrg_id 
	  LEFT JOIN spl AS sp1 ON chrg.automap_spl_cd = sp1.spl_cd 
	    LEFT JOIN spl AS sp2 ON chrg.aprv_spl_cd = sp2.spl_cd 
		  LEFT LOOKUP JOIN fac_cst_cntr AS fcc ON (fcc.cst_cntr_cd = chrg.cst_cntr_cd) AND (fcc.fac_id = f.fac_id) WHERE NOT chrg.del_ind;


SELECT COUNT(*) FROM chrg_cd_copy AS chrg JOIN fac_chrg AS f ON f.chrg_id = chrg.chrg_id 
	LEFT JOIN ems_ent_xlate AS ems ON f.fac_id = ems.fac_id;