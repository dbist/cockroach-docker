# A Secure CockroachDB Cluster with Kerberos and HAProxy acting as load balancer
---

Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)
- Part 5: [Executing CockroachDB table import via GSSAPI](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-5.html)
---

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `kdc` - MIT Kerberos realm
* `client` - postgres-sql client node as CockroachDB < 20.2.alpha3 does not support GSSAPI

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

1) `docker-compose run web django-admin startproject composeexample .`

```bash
14:32 $ docker-compose run web django-admin startproject composeexample .
Starting roach-cert ... done
Starting roach-0    ... done
```

2) Populate example/settings.py with the following

a) ALLOWED_HOSTS = ['0.0.0.0']

b)

## THIS IS NOT USING KERBEROS AS ROOT USER IS FALLBACK

```python
DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'defaultdb',
        'USER': 'root',
        'HOST': 'lb',
        'PORT': '26257',
        'OPTIONS': {
            'sslmode': 'verify-full',
            'sslrootcert': '/certs/ca.crt',
            'sslcert': '/certs/client.root.crt',
            'sslkey': '/certs/client.root.key',
        },
    },
}
```

## KERBEROS EXAMPLE SETTINGS

```python
DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'defaultdb',
        'USER': 'tester',
        'HOST': 'lb',
        'PORT': '26257',
        'OPTIONS': {
            'sslmode': 'verify-ca',
            'sslrootcert': '/certs/ca.crt',
            'krbsrvname': 'customspn',
        },
    },
}
```

3. Run migration

```python
python manage.py migrate
```

```python
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying sessions.0001_initial... OK
```
3) because operation order is important, execute `./up.sh` instead of `docker-compose up`
   - monitor the status of services via `docker-compose logs`
   - in case you need to adjust something in composexample/settings.py, you can
          use `docker-compose logs web`, `docker-compose kill web`, `docker-compose up -d web`
          to debug and proceed.
4) visit the CockroachDB [Admin UI](https://localhost:8080) and login with username `test` and password `password`
5) visit the [HAProxy UI](http://localhost:8081)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh

# shell
docker exec -ti roach-cert /bin/sh

# cli inside the container
cockroach sql --certs-dir=/certs --host=roach-0

# directly
docker exec -ti roach-0 cockroach sql --certs-dir=/certs --host=roach-0
```

6) Connect to `cockroach` using `psql`

```bash
docker exec -it psql bash
psql "postgresql://roach-0:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
```

```sql
root@psql:/# psql "postgresql://roach-0:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt" -U tester
psql (9.5.22, server 9.5.0)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES128-GCM-SHA256, bits: 128, compression: off)
Type "help" for help.

defaultdb=>
```

7) Connect to `cockroach` using `psql` and `krbsrvname`

```bash
docker exec -it psql bash
psql "postgresql://roach-0:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&krbsrvname=customspn" -U tester
```

8) UPDATE with LB SPN only

Using load balancer, `verify-full` does not work, unless the cert SAN is populated. `roach-cert` populates `lb` as part of `create-node` command.

```bash
root@psql:/# psql "postgresql://lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&sslkey=/certs/ca.key" -U tester
psql: server certificate for "roach-1" does not match host name "lb"
root@psql:/# psql "postgresql://lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&sslkey=/certs/ca.key" -U tester
psql: server certificate for "roach-0" does not match host name "lb"
root@psql:/# psql "postgresql://lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&sslkey=/certs/ca.key" -U tester
psql: server certificate for "roach-2" does not match host name "lb"
```

after addressing the SAN, the following works

```bash
psql "postgresql://lb:26257/defaultdb?sslmode=verify-full&sslrootcert=/certs/ca.crt&sslkey=/certs/ca.key" -U tester
```

This works with or without `lb` in the SAN.

```bash
psql "postgresql://lb:26257/defaultdb?sslmode=verify-ca&sslrootcert=/certs/ca.crt&sslkey=/certs/ca.key" -U tester
```
