TODO:
1. figure out how to programmatically update the /etc/hosts file, specifically on the psql machine for `kdc`, `psql` and `cockroach`
2. remove the go stuff
3. clean up the kerberos database and keytab 

# Sample hosts file

192.168.240.5	psql
192.168.240.4   cockroach
# 192.168.240.3	kdc

# Connect to psql
docker exec -it psql bash

# Connect to cockroach
psql "postgresql://cockroach:26257/defaultdb?sslmode=require" -U tester
