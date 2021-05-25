# Use the standard Cockroach image with krb5-user library 
FROM cockroachdb/cockroach:latest-v21.1

LABEL maintainer="artemervits at gmail dot com"
LABEL version="2.0"
LABEL description="native cockroach client container"
ENV REFRESHED_AT 2021_05_25

#RUN apt-get update && \
#  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
#  krb5-user \
#&& rm -rf /var/lib/apt/lists/*

RUN microdnf update && \
    microdnf install \
    krb5-workstation

ENTRYPOINT ["/start.sh"]
