# Use the standard Cockroach image with krb5-user library 
FROM cockroachdb/cockroach:latest-v21.1

LABEL maintainer="artemervits at gmail dot com"
LABEL version="2.0"
LABEL description="native cockroach client container with kerberos utilities"
ENV REFRESHED_AT 2021_05_25

RUN microdnf update && \
    microdnf install \
    krb5-workstation \
    && rm -rf /var/cache/yum

ENTRYPOINT ["/start.sh"]
