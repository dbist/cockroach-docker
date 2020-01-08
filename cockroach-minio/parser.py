#!/usr/bin/python3

import ndjson, glob

files = glob.glob('./data/miniobucket/customer/**/**/*.ndjson')

for i in files:
   with open(i, 'r') as f:
      data = ndjson.load(f)
      #print(data[0]["after"])
      chrg_id = data[0]["after"]["chrg_id"]
      aprv_spl_cd = data[0]["after"]["aprv_spl_cd"]
      automap_spl_cd = data[0]["after"]["automap_spl_cd"]
      chrg_cd_descr = data[0]["after"]["chrg_cd_descr"]
      cst_cntr_cd = data[0]["after"]["cst_cntr_cd"]
      del_ind = data[0]["after"]["del_ind"]
      print('UPSERT INTO chrg_cd VALUES(\'{}\', \'{}\', \'{}\', \'{}\', \'{}\', \'{}\');').format(chrg_id, cst_cntr_cd, chrg_cd_descr, automap_spl_cd, aprv_spl_cd, del_ind)


# print(data[0]["after"]["chrg_id"])

