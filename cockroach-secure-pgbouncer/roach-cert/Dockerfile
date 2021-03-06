# Stage 1 - generate certs
FROM cockroachdb/cockroach:latest-v21.1 AS generator

LABEL maintainer="artemervits at gmail dot com"
LABEL version="7.0"
LABEL description="cockroach cert generator container"
ENV REFRESHED_AT 2021_04_15

RUN mkdir -pv /tmp/certs/ca /tmp/certs/roach-0 /tmp/certs/roach-1 /tmp/certs/roach-2 /tmp/safe /tmp/certs/pgbouncer /tmp/certs/lb /tmp/certs/client

# create CA certificate and distribute to all nodes
RUN cockroach cert create-ca --certs-dir=/tmp/certs/ca --ca-key=/tmp/safe/ca.key \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/client \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/roach-0 \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/roach-1 \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/roach-2 \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/lb \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/pgbouncer

# create root client certificates and distribute to all nodes
RUN cockroach cert create-client root --certs-dir=/tmp/certs/client/ --ca-key=/tmp/safe/ca.key --also-generate-pkcs8-key \
    && cp -v /tmp/certs/client/client.root.* /tmp/certs/roach-0 \
    && cp -v /tmp/certs/client/client.root.* /tmp/certs/roach-1 \
    && cp -v /tmp/certs/client/client.root.* /tmp/certs/roach-2 \
    && cp -v /tmp/certs/client/client.root.* /tmp/certs/lb

# create roach client certificates and distribute to all nodes
RUN ./cockroach cert create-client roach --certs-dir=/tmp/certs/client/ --ca-key=/tmp/safe/ca.key --also-generate-pkcs8-key \
    && cp -v /tmp/certs/client/client.roach.* /tmp/certs/roach-0 \
    && cp -v /tmp/certs/client/client.roach.* /tmp/certs/roach-1 \
    && cp -v /tmp/certs/client/client.roach.* /tmp/certs/roach-2 \
    && cp -v /tmp/certs/client/client.roach.* /tmp/certs/lb

# create each node certificate (cert must have lb and pgbouncer)
RUN cockroach cert create-node roach-0 lb pgbouncer --certs-dir=/tmp/certs/roach-0 --ca-key=/tmp/safe/ca.key
RUN cockroach cert create-node roach-1 lb pgbouncer --certs-dir=/tmp/certs/roach-1 --ca-key=/tmp/safe/ca.key
RUN cockroach cert create-node roach-2 lb pgbouncer --certs-dir=/tmp/certs/roach-2 --ca-key=/tmp/safe/ca.key
RUN cockroach cert create-node pgbouncer --certs-dir=/tmp/certs/pgbouncer --ca-key=/tmp/safe/ca.key

# Stage 2 - share certs
FROM alpine:latest

# need to add a cockroach user to set permissions on certs to non-root, pgbouncer requires it
RUN adduser postgres --no-create-home --disabled-password
RUN mkdir -pv /certs/roach-0 /certs/roach-1 /certs/roach-2 /certs/client /certs/lb /certs/pgbouncer

COPY --from=generator /tmp/certs/roach-0/* /certs/roach-0/
COPY --from=generator /tmp/certs/roach-1/* /certs/roach-1/
COPY --from=generator /tmp/certs/roach-2/* /certs/roach-2/
COPY --from=generator /tmp/certs/client/* /certs/client/
COPY --from=generator /tmp/certs/lb/* /certs/lb/
COPY --from=generator --chown=postgres:postgres /tmp/certs/pgbouncer/* /certs/pgbouncer/
COPY --from=generator --chown=postgres:postgres /tmp/safe/ca.key /certs/pgbouncer/

RUN chmod 400 /certs/pgbouncer/ca.key
RUN chown -R postgres:postgres /certs

CMD tail -f /dev/null
