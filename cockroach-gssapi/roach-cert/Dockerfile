# Stage 1 - generate certs
FROM cockroachdb/cockroach:latest-v21.2 AS generator

LABEL maintainer="artemervits at gmail dot com"
LABEL version="2.0"
LABEL description="cockroach cert generator container"
ENV REFRESHED_AT 2021_11_15

RUN mkdir -pv /tmp/certs/ca /tmp/certs/cockroach /tmp/certs/client /tmp/safe

RUN ./cockroach cert create-ca --certs-dir=/tmp/certs/ca --ca-key=/tmp/safe/ca.key \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/client \
    && cp -v /tmp/certs/ca/ca.crt /tmp/certs/cockroach

RUN ./cockroach cert create-client root --certs-dir=/tmp/certs/client --ca-key=/tmp/safe/ca.key --also-generate-pkcs8-key

RUN cp -v /tmp/certs/client/client.* /tmp/certs/cockroach

RUN ./cockroach cert create-node cockroach lb --certs-dir=/tmp/certs/cockroach --ca-key=/tmp/safe/ca.key

# Stage 2 - share certs

FROM alpine:3

RUN mkdir -pv /certs/cockroach /certs/client

COPY --from=generator  /tmp/certs/cockroach/* /certs/cockroach/
COPY --from=generator  /tmp/certs/client/* /certs/client/

CMD tail -f /dev/null
