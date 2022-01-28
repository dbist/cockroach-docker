# Stage 1 - generate certs
FROM prom/prometheus

LABEL maintainer="artemervits at gmail dot com"
LABEL version="1.0"
LABEL description="prometheus container"
ENV REFRESHED_AT 2022_01_27

COPY prometheus.yml .
COPY rules .


