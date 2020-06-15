####################################
#   Multi-stage build
#       1. generate certs
#       2. share certs
####################################

# Stage 1 - generate certs

FROM debian:9.8-slim as generator

ARG DEBIAN_FRONTEND=noninteractive

# todo: see if i can fix the slowness.  is this not specifying correct alias for create-node
# todo: should secure run under something than 8080

LABEL maintainer="tjveil@gmail.com"

ARG CRDB_DOWNLOAD_URL=https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz
ARG CRDB_DOWNLOAD_DIR=/tmp/crdb
ARG CRDB_HOME=/opt/crdb

ENV PATH=$CRDB_HOME:$PATH

RUN mkdir -pv /tmp/certs/ca /tmp/certs/web /tmp/certs/roach-0 /tmp/safe /tmp/certs/client

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils libc6 curl ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -pv $CRDB_DOWNLOAD_DIR \
    && mkdir -pv $CRDB_DOWNLOAD_DIR \
    && curl -fSL "$CRDB_DOWNLOAD_URL" -o /tmp/crdb.tgz \
    && tar -xvf /tmp/crdb.tgz -C $CRDB_DOWNLOAD_DIR --strip-components=1 \
    && mv -v $CRDB_DOWNLOAD_DIR /opt \
    && rm -rfv /tmp/crdb.tgz

RUN cockroach cert create-ca --certs-dir=/tmp/certs/ca --ca-key=/tmp/safe/ca.key \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/client \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/roach-0

RUN cockroach cert create-client root --certs-dir=/tmp/certs/client --ca-key=/tmp/safe/ca.key
RUN cockroach cert create-client maxroach --certs-dir=/tmp/certs/client --ca-key=/tmp/safe/ca.key

RUN cp -v /tmp/certs/client/client.* /tmp/certs/roach-0

RUN cockroach cert create-node roach-0 --certs-dir=/tmp/certs/roach-0 --ca-key=/tmp/safe/ca.key

# Stage 2 - share certs

FROM alpine:latest

LABEL maintainer="generic 13 at gmail.com"

RUN mkdir -pv /certs/roach-0

COPY --from=generator  /tmp/certs/roach-0/* /certs/roach-0/

CMD tail -f /dev/null