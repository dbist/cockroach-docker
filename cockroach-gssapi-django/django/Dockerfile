FROM python:3
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.3"
ENV REFRESHED_AT 2020_08_07
ENV PYTHONUNBUFFERED 1
RUN mkdir /code/
WORKDIR /code/
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/start.sh"]
