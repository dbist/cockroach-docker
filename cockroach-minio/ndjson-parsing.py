import ndjson

# load from file-like objects
with open('./data/miniobucket/customer/chrg_cd/2020-01-08/202001082012357835517000000000001-069e62e4a1ee1617-1-7-00000003-chrg_cd-1.ndjson') as f:
    data = ndjson.load(f)

# convert to and from objects
text = ndjson.dumps(data)
data = ndjson.loads(text)

#print a JSON record
print(data[0]["after"])

#print chrg_id
print(data[0]["after"]["chrg_id"])

## dump to file-like objects
#with open('backup.ndjson', 'w') as f:
#    ndjson.dump(items, f)
