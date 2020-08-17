FROM python:3
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.4"
ENV REFRESHED_AT 2020_08_13
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN python -m pip install --upgrade pip && \
  pip install -r requirements.txt
COPY . /code/
ENTRYPOINT ["./sqlalchemy/start.sh"]
