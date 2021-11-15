# Build the test binary in a multistage build.
FROM postgres:14.1

LABEL maintainer="artemervits at gmail dot com"
LABEL version="2.0"
LABEL description="psql client container"
ENV REFRESHED_AT 2021_11_15

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user \
&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/start.sh"]
