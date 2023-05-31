FROM python:3-slim
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.4"
ENV REFRESHED_AT 2021_03_04
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    libpq-dev \
    python3-dev \
&& rm -rf /var/lib/apt/lists/*
COPY composeexample /code/composeexample
COPY requirements.txt /code/
COPY manage.py /code/
RUN pip3 install --upgrade pip; pip3 install -r requirements.txt