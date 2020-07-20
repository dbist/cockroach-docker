FROM python:3.7-slim
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.2"
ENV REFRESHED_AT 2020_07_20
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    libpq-dev \
    python3-dev \
&& rm -rf /var/lib/apt/lists/*
COPY requirements.txt /code/
RUN pip3 install --upgrade pip; pip3 install -r requirements.txt
