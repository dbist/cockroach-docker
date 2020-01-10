#!/usr/bin/python3

import ndjson, glob, sys

# chrg_cd
chrg_cd_output = open('chrg_cd.sql', 'w')
chrg_cd = glob.glob('./data/miniobucket/customer/materialized/**/**.ndjson')
count = 0
for i in chrg_cd:
   with open(i, 'r') as f:
      for line in f:
        data = ndjson.loads(line)
        # spl table
        #if checkKey(data[0]["after"], "spl_cd"):
        #    spl_cd = data[0]["after"]["spl_cd"]

        # fac_chrg table
        if "chrg_cd" and "chrg_id" and "eff_dt" in data[0]["after"].keys():
            chrg_cd = data[0]["after"]["chrg_cd"]
            chrg_id = data[0]["after"]["chrg_id"]
            eff_dt = data[0]["after"]["eff_dt"]
            fac_id = data[0]["after"]["fac_id"]
            
        # chrg_cd table
        if "chrg_id" and "aprv_spl_cd" and "automap_spl_cd" and "chrg_cd_descr" and "cst_cntr_cd" and "del_ind" in data[0]["after"].keys():
            chrg_id = data[0]["after"]["chrg_id"]
            aprv_spl_cd = data[0]["after"]["aprv_spl_cd"]
            automap_spl_cd = data[0]["after"]["automap_spl_cd"]
            chrg_cd_descr = data[0]["after"]["chrg_cd_descr"]
            cst_cntr_cd = data[0]["after"]["cst_cntr_cd"]
            del_ind = data[0]["after"]["del_ind"]
            #print(chrg_id, aprv_spl_cd, automap_spl_cd, chrg_cd_descr, cst_cntr_cd, del_ind)
        
        # spl table
        if "spl_cd" in data[0]["after"].keys():
            spl_cd = data[0]["after"]["spl_cd"]



