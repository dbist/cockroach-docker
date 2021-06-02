# Use the standard Cockroach image with krb5-user library 
FROM cockroachdb/cockroach:latest-v21.1

LABEL maintainer="artemervits at gmail dot com"
LABEL version="3.0"
LABEL description="native cockroach client container with kerberos utilities"
ENV REFRESHED_AT 2021_06_02

RUN rpm -ivh http://rpmfind.net/linux/centos/8.3.2011/BaseOS/x86_64/os/Packages/c-ares-1.13.0-5.el8.x86_64.rpm && \
    rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf update && \
    microdnf install \
    krb5-workstation \
    postgresql13 \
    && rm -rf /var/cache/yum

ENTRYPOINT ["/start.sh"]
