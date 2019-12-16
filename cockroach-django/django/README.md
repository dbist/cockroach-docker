Django [tutorial](https://docs.djangoproject.com/en/3.0/intro/tutorial01/)
Running CockroachDB in [Docker](https://www.cockroachlabs.com/docs/stable/start-a-local-cluster-in-docker-mac.html)
docker build -t="dbist/cockroach-django" .
docker run -t -d -v /Users/artem/Documents/cockroach-work/cockroach-django/django/app:/app --name web -p 8000:8000 dbist/cockroach-django:latest
docker exec -it ID-of-Django-container bash
/app# django-admin startproject mysite
cd mysite
python manage.py runserver 0:8000
browse on host machine to localhost:8000
now since we mapped a volume `/app` to container, open `settings.py` in mysite dir on the host
use `docker inspect roach1` command to get IP address of one of the nodes, in this case `roach1`

populate `settings.py` with that info

```

DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'myproject',
        'USER': 'myprojectuser',
        'PASSWORD': '',
        'HOST': '172.20.0.4',
        'PORT': '26257',
    }
}
```
replace files in the container with pre-existing code

```bash
python manage.py migrate
```

```bash
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sessions
Running migrations:
  No migrations to apply.
```

add the following to settings.py

```
INSTALLED_APPS = [
    'polls.apps.PollsConfig',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

```bash
python manage.py makemigrations polls
```

```bash
Migrations for 'polls':
  polls/migrations/0001_initial.py
    - Create model Question
    - Create model Choice
```


```
python manage.py sqlmigrate polls 0001
```

```bash
root@26047ce9fcbc:/app/mysite# python manage.py sqlmigrate polls 0001
BEGIN;
--
-- Create model Question
--
CREATE TABLE "polls_question" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "question_text" varchar(200) NOT NULL, "pub_date" datetime NOT NULL);
--
-- Create model Choice
--
CREATE TABLE "polls_choice" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "choice_text" varchar(200) NOT NULL, "votes" integer NOT NULL, "question_id" integer NOT NULL REFERENCES "polls_question" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "polls_choice_question_id_c5b4b260" ON "polls_choice" ("question_id");
COMMIT;
root@26047ce9fcbc:/app/mysite#
```

```
python manage.py migrate
```

```bash
root@26047ce9fcbc:/app/mysite# python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, polls, sessions
Running migrations:
  Applying polls.0001_initial... OK
```

follow along in part 2 of tutorial, should be working fine https://docs.djangoproject.com/en/3.0/intro/tutorial02/


