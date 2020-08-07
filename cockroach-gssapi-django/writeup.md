# CockroachDB with Django and MIT Kerberos
------------------------------------------------------
- Part 1: [CockroachDB with MIT Kerberos](https://blog.ervits.com/2020/05/three-headed-dog-meet-cockroach.html)
- Part 2: [CockroachDB with Active Directory](https://blog.ervits.com/2020/06/three-headed-dog-meet-cockroach-part-2.html)
- Part 3: [CockroachDB with MIT Kerberos and Docker Compose](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-3.html)
- Part 4: [CockroachDB with MIT Kerberos and custom SPN](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach.html)
- Part 5: [Executing CockroachDB table import via GSSAPI](https://blog.ervits.com/2020/07/three-headed-dog-meet-cockroach-part-5.html)
- Part 6: [Three-headed dog meet cockroach, part 6: CockroachDB, MIT Kerberos, HAProxy and Docker Compose](https://blog.ervits.com/2020/08/three-headed-dog-meet-cockroach-part-6.html)
- Part 7: [CockroachDB with MIT Kerberos and Django](https://blog.ervits.com/2020/08/cockroachdb-with-django-and-mit-kerberos.html)
---

Today, I'm going to demonstrate how to leverage CockroachDB with MIT Kerberos and the Django project. We have a lot of customers using us for their Python database needs and you can view some of the options on our [docs](https://www.cockroachlabs.com/docs/stable/build-a-python-app-with-cockroachdb-django.html) site.
For today's setup, I have a multi-node CockroachDB cluster, a Django container calles web, a load balancer container and Kerberos kdc container. You can find the code for this example on my [repo](https://github.com/dbist/cockroach-docker/tree/master/cockroach-gssapi-django). My example is a slight modification of the one you can find from [Docker](https://docs.docker.com/compose/django/).

1. Clone the repo

```bash
git clone https://github.com/dbist/cockroach-docker
cd cockroach-docker/cockroach-gssapi-django
```

1. Create a django project
 
As I said, my version is a bit different from the one on the Docker website, as I'm adding a Kerberos Distribution Center, a load balancer and a three node CockroachDB cluster. Otherwise pretty much everything else is the same. What does not work is creating a project via the container like in the Docker quickstart. So `docker-compose run web django-admin startproject composeexample .` won't work as I have additional adding an entrypoint in my Django container to kinit to the kdc. This is a small price to pay so instead, we're going to run this manually.

a) Install Django locally

```bash
pip3 install django==2.2
```

```bash
Collecting django==2.2
  Using cached Django-2.2-py3-none-any.whl (7.4 MB)
Requirement already satisfied: pytz in /usr/local/lib/python3.8/site-packages (from django==2.2) (2020.1)
Requirement already satisfied: sqlparse in /usr/local/lib/python3.8/site-packages (from django==2.2) (0.3.1)
Installing collected packages: django
  Attempting uninstall: django
    Found existing installation: Django 3.1
    Uninstalling Django-3.1:
      Successfully uninstalled Django-3.1
Successfully installed django-2.2
```

Django 2.2 is the current long term release but this setup works with Django 3.0 and 3.1 as well and I'll cover that in a bit.

b) Create a project

In the root of the docker-compose directory, initialize a new Django project

```bash
django-admin startproject example .
```

Now you should see a directory called example and a file called manage.py.

2. Edit the django properties file

edit the example/settings.py with the following properties

```python
ALLOWED_HOSTS = ['*']
```

```python
DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'defaultdb',
        'USER': 'tester',
        'HOST': 'lb',
        'PORT': '26257',
        'OPTIONS': {
            'sslmode': 'verify-full',
            'sslrootcert': '/certs/ca.crt',
        },
    },
}
```

This is not much different from the standard Django properties except for the following subtle differences. 

`ENGINE` is our cockroachdb native driver for Django, `NAME` is the database name, `USER` is a user in our Kerberos KDC, `HOST` points to our load balancer instance, please review the previous articles if you need further context on that. We also include `sslmode` and `sslrootcert` to verify the authenticity of our clients and nodes.

3. Verify the requirements file has the proper version of Django and cockroachdb driver.

```bash
cd ./django
vi requirements.txt
```

Uncomment the desired versions of Django and cockroachdb driver.

4. Run `./up.sh` script to start the environment

```bash
./up.sh
cockroach uses an image, skipping
Building roach-cert
Step 1/15 : FROM cockroachdb/cockroach:v20.1.4 AS generator
 ---> 25bee4f016c4
...
SET CLUSTER SETTING

Time: 8.1053ms
```

5. Check to make sure all containers are up

```bash
docker-compose ps
```

```bash
kdc          /start.sh                        Up
lb           /docker-entrypoint.sh hapr ...   Up      0.0.0.0:26257->26257/tcp,
                                                      5432/tcp,
                                                      0.0.0.0:8080->8080/tcp,
                                                      0.0.0.0:8081->8081/tcp
roach-0      /cockroach/cockroach.sh st ...   Up      26257/tcp, 8080/tcp
roach-1      /cockroach/cockroach.sh st ...   Up      26257/tcp, 8080/tcp
roach-2      /cockroach/cockroach.sh st ...   Up      26257/tcp, 8080/tcp
roach-cert   /bin/sh -c tail -f /dev/null     Up
web          /start.sh python manage.py ...   Up      0.0.0.0:8000->8000/tcp
```

6. Inspect the logs for the web container

```bash
docker logs web
```

```bash
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).

You have 17 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
August 07, 2020 - 19:41:52
Django version 2.2.15, using settings 'example.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```

We can see the server is up, we can navigate to the Django [portal](http://localhost:8000/) from your host.

I had a customer ask how to pass a custom SPN to Django project. It was not documented and not so intuitive but after some trial and error, the following was achieved by addition of the `krbsrvname` to the example/settings.py file.

7. Django with custom SPN

```python
DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'defaultdb',
        'USER': 'tester',
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

Tear down the environment with a helper script called `./down.sh` and restart it with `./up.sh`. 

```bash
You have 17 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
August 07, 2020 - 19:55:59
Django version 2.2.15, using settings 'example.settings'
Starting development server at http://0.0.0.0:8000/
Quit the server with CONTROL-C.
```

Let's apply those migrations!

8. Apply migration

```bash
docker-compose exec web python manage.py migrate
```

```bash
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

9. Upgrade Django

There are many [reasons](https://docs.djangoproject.com/en/3.1/howto/upgrade-version/) to upgrade Django. Let's do that with our project.

We need to edit our `django/requirements.txt` file to match the target version of Django, in our case 3.1.

```bash
# Django 3.1
Django>=3.1.*
django-cockroachdb>=3.1.*
```

Tear down the environment with down.sh and start it up again with up.sh. Navigate to the django portal and you will see the new version.

PLACEHOLDER django_3.1

And just so there are no doubts, let's connect to the web container and see whether connection has been made with Kerberos

```bash
docker exec -ti web sh
klist
```

```bash
Default principal: tester@EXAMPLE.COM

Valid starting     Expires            Service principal
08/07/20 20:11:20  08/08/20 20:11:20  krbtgt/EXAMPLE.COM@EXAMPLE.COM
	renew until 08/07/20 20:11:20
08/07/20 20:11:31  08/08/20 20:11:20  customspn/lb@
	renew until 08/07/20 20:11:20
08/07/20 20:11:31  08/08/20 20:11:20  customspn/lb@EXAMPLE.COM
	renew until 08/07/20 20:11:20
```

That's it for today, hope you enjoyed this tour of Django with Kerberos.


