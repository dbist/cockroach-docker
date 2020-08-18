FROM maven:3-openjdk-8 AS builder
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.1"
ENV REFRESHED_AT 2020_08_17

COPY . /
WORKDIR /roach-data/roach-data-jdbc
RUN mvn clean install

FROM openjdk:8 AS runner

RUN mkdir /usr/src/app
WORKDIR /usr/src/app
COPY --from=builder /roach-data/roach-data-jdbc/target/roach-data-jdbc.jar .
CMD ["java", "-jar", "roach-data-jdbc.jar"]
