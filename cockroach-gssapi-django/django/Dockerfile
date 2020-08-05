FROM python:3.8-alpine
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.3"
ENV REFRESHED_AT 2020_08_04
ENV PYTHONUNBUFFERED 1
RUN mkdir code
COPY requirements.txt code/
WORKDIR code
RUN apk update && apk add --no-cache --virtual .build-deps \
    postgresql-dev gcc libpq python3-dev musl-dev linux-headers \
    krb5-libs \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps\
    && rm -rf /var/cache/apk/*
RUN tail /dev/null
