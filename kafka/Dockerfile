FROM ubuntu
LABEL maintainer="artemervits at gmail dot com"

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O kafka_2.11-2.0.0.tgz https://archive.apache.org/dist/kafka/2.0.0/kafka_2.11-2.0.0.tgz
RUN tar -xzf kafka_2.11-2.0.0.tgz
RUN mv kafka_2.11-2.0.0 /opt/kafka
RUN rm kafka_2.11-2.0.0.tgz
