# A Secure CockroachDB Cluster with Kerberos, Django and HAProxy acting as load balancer
---

Check out my series of articles on CockroachDB and Kerberos below:

- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)
- Part 5: [Executing CockroachDB table import via GSSAPI](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-5.html)
- Part 6: [Three-headed dog meet cockroach, part 6: CockroachDB, MIT Kerberos, HAProxy and Docker Compose](https://blog.ervits.com/2020/08/three-headed-dog-meet-cockroach-part-6.html)
- Part 7: [CockroachDB with MIT Kerberos and Django](https://blog.ervits.com/2020/08/cockroachdb-with-django-and-mit-kerberos.html)
---

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `kdc` - MIT Kerberos realm
* `web` - django server

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.
---

Docker compose is based on the Docker [demo app](https://docs.docker.com/compose/django/). The Django application with CockroachDB is based on theCockroachDB Django [tutorial](https://docs.docker.com/compose/django/). Feel free to read the article [7](#Part 7) above.

1. Unlike the Docker tutorial, we must initialize the project directory using a local django as our example expects KDC to be present at the time of initialization and the below command will not work 

`docker-compose run web django-admin startproject composeexample .`

Because I'm using ENTRYPOINT in django Dockerfile as oppose to the original docker-compose [example](https://docs.docker.com/compose/django/). My entrypoint expects kerberos present.

```bash
14:32 $ docker-compose run web django-admin startproject composeexample .
Starting roach-cert ... done
Starting roach-0    ... done
```

Generate project structure with `django-admin startproject myproject .` using locally installed django package and not rely on docker.

```bash
pip3 install django==3.0
Collecting django==3.0
  Using cached Django-3.0-py3-none-any.whl (7.4 MB)
Requirement already satisfied: pytz in /usr/local/lib/python3.8/site-packages (from django==3.0) (2020.1)
Requirement already satisfied: asgiref~=3.2 in /usr/local/lib/python3.8/site-packages (from django==3.0) (3.2.10)
Requirement already satisfied: sqlparse>=0.2.2 in /usr/local/lib/python3.8/site-packages (from django==3.0) (0.3.1)
Installing collected packages: django
  Attempting uninstall: django
    Found existing installation: Django 2.2
    Uninstalling Django-2.2:
      Successfully uninstalled Django-2.2
Successfully installed django-3.0
```

```bash
django-admin startproject example_django_3_0 .
```

## For Django 3.1, etc

```bash
pip3 install django==3.1
```

2. Populate the myproject/myproject/settings.py with the following

a) ALLOWED_HOSTS = ['*']

b)

This is an example of ssl authentication to Django using root user (fallback)

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

This is a Kerberos example

```python
DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'bank',
        'USER': 'django',
        'HOST': 'lb',
        'PORT': '26257',
        'OPTIONS': {
            'sslmode': 'verify-full',
            'sslrootcert': '/certs/ca.crt',
            'krbsrvname': 'customspn',
        },
    },
}
```

c) Add `myproject` to the list of installed apps

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'myproject',
]
```

3. Write the application logic

Use the source code in the CockroachDB Django tutorial.

4. Setup and run the Django app

```bash
docker exec -it bash sh
```

```bash
python manage.py makemigrations myproject
```

```python
Migrations for 'myproject':
  myproject/migrations/0001_initial.py
    - Create model Customers
    - Create model Products
    - Create model Orders
```

```bash
python manage.py migrate
```

```python
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, myproject, sessions
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
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying myproject.0001_initial... OK
  Applying sessions.0001_initial... OK
```

5. Connect to CockroachDB to confirm all of the new tables created

```bash
docker exec -it roach-0 sh
cockroach sql --certs-dir=/certs --host=roach-0:26257
```

```sql
root@roach-0:26257/defaultdb> use bank;
SET

Time: 1.5895ms

root@roach-0:26257/bank> show tables;
          table_name
------------------------------
  auth_group
  auth_group_permissions
  auth_permission
  auth_user
  auth_user_groups
  auth_user_user_permissions
  django_admin_log
  django_content_type
  django_migrations
  django_session
  myproject_customers
  myproject_orders
  myproject_orders_product
  myproject_products
(14 rows)
```

5. Start the server if not started, [django UI](https://localhost:9999) should be able to tell.

```bash
python manage.py runserver 0.0.0.0:8000
```

```bash
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).
August 13, 2020 - 18:44:12
Django version 3.1, using settings 'myproject.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```

## NOTE: may need to stop and start the web node as kinit is having trouble getting password

`docker-compose restart web`

6. Interact with Django and CockroachDB

a) send a POST command

```bash
docker exec -it web curl --header "Content-Type: application/json" --request POST --data '{"name":"Carl"}' http://0.0.0.0:8000/customer/
```

b) send a GET command

```bash
docker exec -it web curl http://0.0.0.0:8000/customer/
```

```bash
[{"id": 580891142121062403, "name": "Carl"}]
```

Verifying the same by accessing the database

```bash
docker exec -ti roach-0 sh
cockroach sql --host=roach-0 --certs-dir=/certs --execute="select * from bank.myproject_customers;"
```

```bash
          id         | name
---------------------+-------
  580891142121062403 | Carl
(1 row)
```

---

Summary: Order is important, execute `./up.sh` instead of `docker-compose up`
   - monitor the status of services via `docker-compose logs`
   - in case you need to adjust something in myproject/settings.py, you can
          use `docker-compose logs web`, `docker-compose kill web`, `docker-compose up -d web`
          to debug and proceed.
- CockroachDB Admin [UI](https://localhost:8080) and login with username `test` and password `password`
- HAProxy [UI](http://localhost:8081)
- Django [UI](http://localhost:8000)

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti web sh
docker exec -ti kdc sh
docker exec -ti roach-cert /bin/sh
```

Cockroach CLI

```bash
cockroach sql --certs-dir=/certs --host=roach-0
```

Verifying Kerberos

```bash
docker exec -ti web sh
klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: django@EXAMPLE.COM

Valid starting     Expires            Service principal
08/13/20 18:44:02  08/14/20 18:44:02  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 08/13/20 18:44:02
08/13/20 18:44:12  08/14/20 18:44:02  customspn/lb@
	renew until 08/13/20 18:44:02
08/13/20 18:44:12  08/14/20 18:44:02  customspn/lb@EXAMPLE.COM
	renew until 08/13/20 18:44:02

kdestroy
kinit django
Password for django@EXAMPLE.COM:
klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: django@EXAMPLE.COM

Valid starting     Expires            Service principal
08/13/20 19:01:23  08/14/20 19:01:23  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 08/13/20 19:01:23
```
