# Use the standard Cockroach image with krb5-user library 
FROM cockroachdb/cockroach-unstable:v20.2.0-beta.3

LABEL maintainer="artemervits at gmail dot com"
LABEL version="1.0"
LABEL description="native cockroach client container"
ENV REFRESHED_AT 2020_10_01

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user \
&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/start.sh"]
