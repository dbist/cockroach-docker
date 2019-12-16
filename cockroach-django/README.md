# Secure CockroachDB Cluster with Django, inspired by [Docker tutorial](https://docs.docker.com/compose/django/)
Simple 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

Prerequisites:
1. requires [107](https://github.com/cockroachdb/django-cockroachdb/issues/107)

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `web` - Django node

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`. 

1) `docker-compose run web django-admin startproject composeexample .`
	- populate composeexample/settings.py with database-specific properties
	- e.g.
```
DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'myproject',
        'USER': 'myprojectuser',
        'PASSWORD': 'password',
        'HOST': 'roach-0',
        'PORT': '26257',
        'OPTIONS': {
            'sslmode': 'require',
        },
    }
}
```

2) because operation order is important, execute `./up.sh` instead of `docker-compose up`
	- monitor the status of services via `docker-compose logs`
3) visit the CockroachDB UI @ https://localhost:8080 and login with username `test` and password `password`
4) visit the HAProxy UI @ http://localhost:8081
5) visit the Django webpage @ http://localhost:8000
6) have fun!

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti roach-cert /bin/sh
docker exec -ti web /bin/bash
```
