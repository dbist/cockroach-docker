FROM python:slim-bullseye
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.1"
ENV REFRESHED_AT 2022_06_09
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
&& rm -rf /var/lib/apt/lists/*
WORKDIR /flask
RUN pip3 install --upgrade pip; pip3 install -r requirements.txt

ENV DATABASE_URL="postgresql://root@lb:26257/flask_db?sslcert=%2Fcerts%2Fclient.root.crt&sslkey=%2Fcerts%2Fclient.root.key&sslmode=verify-full&sslrootcert=%2Fcerts%2Fca.crt"

#RUN python init_db.sql

#ENTRYPOINT ["./django/docker-entrypoint.sh"]
