# Secure CockroachDB Cluster with Django, inspired by [Docker tutorial](https://docs.docker.com/compose/django/)
Simple 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

Prerequisites:

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

```bash
14:32 $ docker-compose run web django-admin startproject composeexample .
Starting roach-cert ... done
Starting roach-0    ... done
```

2) populate composeexample/settings.py with database-specific properties

```python
DATABASES = {
    'default': {
        'ENGINE': 'django_cockroachdb',
        'NAME': 'myproject',
        'USER': 'myprojectuser',
        'HOST': 'roach-0',
        'PORT': '26257',
        'OPTIONS': {
            'sslmode': 'verify-full',
            'sslrootcert': '/certs/ca.crt',
            'sslcert': '/certs/client.myprojectuser.crt',
            'sslkey': '/certs/client.myprojectuser.key',
        },
    },
}
```

3) because operation order is important, execute `./up.sh` instead of `docker-compose up`
	- monitor the status of services via `docker-compose logs`
        - in case you need to adjust something in composexample/settings.py, you can
          use `docker-compose logs web`, `docker-compose kill web`, `docker-compose up -d web`
          to debug and proceed.
4) visit the CockroachDB UI @ https://localhost:8080 and login with username `test` and password `password`
5) visit the HAProxy UI @ http://localhost:8081
6) visit the Django webpage @ http://localhost:8000

### Open Interactive Shells
```bash
docker exec -ti roach-0 /bin/bash
docker exec -ti roach-1 /bin/bash
docker exec -ti roach-2 /bin/bash
docker exec -ti lb /bin/sh
docker exec -ti roach-cert /bin/sh
docker exec -ti web /bin/bash
```
