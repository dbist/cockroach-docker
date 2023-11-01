FROM maven:latest

LABEL maintainer="artemervits at gmail dot com"
LABEL version="1.0"
LABEL description="maven container"
ENV REFRESHED_AT 2023_11_01

COPY ./jooq-basic-sample /jooq-basic-sample
WORKDIR /jooq-basic-sample
RUN mvn compile
#RUN mvn exec:java -Dexec.mainClass=com.cockroachlabs.Sample