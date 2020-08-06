FROM python:3
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.3"
ENV REFRESHED_AT 2020_08_06
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code

# alpine doesn't work for some ambiguous python issue, possibly the lack
# of `gssapi` pypi package, tested and failed with 1.6.9
#FROM python:3-alpine
#LABEL maintainer="artemervits at gmail dot com"
#LABEL version="0.3"
#ENV REFRESHED_AT 2020_08_04
#ENV PYTHONUNBUFFERED 1
#RUN mkdir code
#COPY requirements.txt code/
#WORKDIR code
#RUN apk update && apk add --no-cache postgresql-dev gcc python3-dev musl-dev \
#    && pip install --no-cache-dir -r requirements.txt \
#    && apk add --no-cache krb5 libpq \
#    && rm -rf /var/cache/apk/*
