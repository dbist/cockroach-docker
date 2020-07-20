# Build the test binary in a multistage build.
FROM postgres:9.5

LABEL maintainer="artemervits at gmail dot com"
LABEL version="1.0"
LABEL description="psql client container"
ENV REFRESHED_AT 2020_07_20

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user \
&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/start.sh"]
