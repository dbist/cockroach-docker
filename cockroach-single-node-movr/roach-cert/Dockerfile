# Stage 1 - generate certs
FROM cockroachdb/cockroach:v20.1.3 AS generator

LABEL maintainer="artemervits at gmail dot com"
LABEL version="1.0"
LABEL description="cockroach cert generator container"
ENV REFRESHED_AT 2020_07_20

RUN mkdir -pv /tmp/certs/ca /tmp/certs/roach-0 /tmp/certs/client /tmp/safe

RUN ./cockroach cert create-ca --certs-dir=/tmp/certs/ca --ca-key=/tmp/safe/ca.key \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/client \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/roach-0

RUN ./cockroach cert create-client root --certs-dir=/tmp/certs/client --ca-key=/tmp/safe/ca.key --also-generate-pkcs8-key

RUN cp -v /tmp/certs/client/client.* /tmp/certs/roach-0

RUN ./cockroach cert create-node roach-0 localhost --certs-dir=/tmp/certs/roach-0 --ca-key=/tmp/safe/ca.key

# Stage 2 - share certs

FROM alpine:3.12

RUN mkdir -pv /certs/roach-0 /certs/client

COPY --from=generator  /tmp/certs/roach-0/* /certs/roach-0/
COPY --from=generator  /tmp/certs/client/* /certs/client/

CMD tail -f /dev/null
