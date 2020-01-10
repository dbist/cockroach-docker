#!/usr/bin/python3

import ndjson, glob, sys
#import psycopg2
#import psycopg2.errorcodes
import time
import logging
import random

# chrg_cd
chrg_cd_output = open('chrg_cd.sql', 'w')
fac_chrg_output = open('fac_chrg.sql', 'w')
spl_output = open('spl.sql', 'w')
files = glob.glob('./data/miniobucket/customer/materialized/**/**.ndjson')
chrg_cd_count = 0
fac_chrg_count = 0
spl_count = 0

for i in files:
   with open(i, 'r') as f:
      for line in f:
         data = ndjson.loads(line)
         
         # chrg_cd table
         if "chrg_id" and "aprv_spl_cd" and "automap_spl_cd" and "chrg_cd_descr" and "cst_cntr_cd" and "del_ind" in data[0]["after"].keys():
            # handle INSERT/UPDATE
            chrg_id = data[0]["after"]["chrg_id"]
            aprv_spl_cd = data[0]["after"]["aprv_spl_cd"]
            automap_spl_cd = data[0]["after"]["automap_spl_cd"]
            chrg_cd_descr = data[0]["after"]["chrg_cd_descr"]
            cst_cntr_cd = data[0]["after"]["cst_cntr_cd"]
            del_ind = data[0]["after"]["del_ind"]
            record = ('UPSERT INTO materialized_table (chrg_id, cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind) VALUES(\'{}\', \'{}\', \'{}\', \'{}\', \'{}\', \'{}\');\n').format(chrg_id, cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind)
            chrg_cd_output.write(record)
            chrg_cd_count+=1
     
         # fac_chrg table
         elif "chrg_cd" and "chrg_id" and "eff_dt" in data[0]["after"].keys():
            # handle INSERT/UPDATE
            chrg_cd = data[0]["after"]["chrg_cd"]
            chrg_id = data[0]["after"]["chrg_id"]
            eff_dt = data[0]["after"]["eff_dt"]
            fac_id = data[0]["after"]["fac_id"]
            record = ('UPSERT INTO materialized_table (chrg_cd, chrg_id, eff_dt, fac_id) VALUES(\'{}\', \'{}\', \'{}\', \'{}\');\n').format(chrg_cd, chrg_id, eff_dt, fac_id)
            fac_chrg_output.write(record)
            fac_chrg_count+=1
         
         elif "spl_cd" in data[0]["after"].keys():
            # handle INSERT/UPDATE
            spl_cd = data[0]["after"]["spl_cd"]
            record = ('UPSERT INTO materialized_table (spl_cd) VALUES (\'{}\');\n').format(spl_cd)
            spl_output.write(record)
            spl_count+=1
              # check whether chrg_cd is not a delete 
             #if data[0]["after"]["chrg_id"] != None:
              #    # handle DELETE
               #   record = ('DELETE FROM materialized_table WHERE chrg_id = \'{}\';\n').format(data[0]["key"][0])
                #  fac_chrg_output.write(record)
                 # fac_chrg_count+=1
                 #   print(data[0]["key"]) # will print delete key



print("Record count chrg_cd: {}".format(chrg_cd_count))
print("Record count fac_chrg: {}".format(fac_chrg_count))
print("Record count spl: {}".format(spl_count))
chrg_cd_output.close()
fac_chrg_output.close()
spl_output.close()

# fac_chrg





