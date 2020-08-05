#!/bin/sh

set -e

# The /keytab directory is volume mounted on both kdc and cockroach. kdc
# can create the keytab with kadmin.local here and it is then useable
# by cockroach.

kadmin.local -q "ktadd -k /keytab/crdb.keytab postgres/lb@EXAMPLE.COM"

# This is an example of overriding postgres SPN
kadmin.local -q "ktadd -k /keytab/crdb.keytab customspn/lb@EXAMPLE.COM"

# this is for backwards compatibility, not really necessary
kadmin.local -q "ktadd -k /keytab/crdb.keytab postgres/cockroach@EXAMPLE.COM"
kadmin.local -q "ktadd -k /keytab/crdb.keytab customspn/cockroach@EXAMPLE.COM"

krb5kdc -n
