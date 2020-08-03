#!/bin/sh

set -e

# The /keytab directory is volume mounted on both kdc and cockroach. kdc
# can create the keytab with kadmin.local here and it is then useable
# by cockroach.

kadmin.local -q "ktadd -k /keytab/crdb.keytab postgres/lb@EXAMPLE.COM"

# This is an example of overriding postgres SPN
kadmin.local -q "ktadd -k /keytab/crdb.keytab customspn/lb@EXAMPLE.COM"

krb5kdc -n
