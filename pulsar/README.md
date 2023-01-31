
## create tenant

bin/pulsar-admin tenants create tpcc-tenant

## create namespace

bin/pulsar-admin namespaces create tpcc-tenant/tpcc-namespace

## create topics

bin/pulsar-admin topics create persistent://tpcc-tenant/tpcc-namespace/office_dogs


```sql
SET CLUSTER SETTING cluster.organization = 'Cockroach Labs - Production Testing';
SET CLUSTER SETTING enterprise.license = 'crl-0-EJL04ukFGAEiI0NvY2tyb2FjaCBMYWJzIC0gUHJvZHVjdGlvbiBUZXN0aW5n';
```

```sql
SET CLUSTER SETTING kv.rangefeed.enabled = true;
CREATE CHANGEFEED FOR TABLE office_dogs INTO 'pulsar://pulsar:6650' with updated;
```

```sql
ERROR: unsupported sink: pulsar
```

```sql
CREATE CHANGEFEED FOR TABLE office_dogs INTO 'http://pulsar:8080/tpcc-tenant/tpcc-namespace/warehouse' with updated;
```

```sql
        job_id
----------------------
  835983411569917953
```
