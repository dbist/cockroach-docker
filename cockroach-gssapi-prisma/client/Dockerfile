# Use the standard Cockroach image with krb5-user library
FROM cockroachdb/cockroach:latest-v21.2

LABEL maintainer="artemervits at gmail dot com"
LABEL version="4.0"
LABEL description="native cockroach client container with kerberos utilities"
ENV REFRESHED_AT 2021_11_15

RUN rpm -ivh http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/c/c-ares-1.17.2-2.fc36.x86_64.rpm && \
    rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf update && \
    microdnf install \
    krb5-workstation \
    postgresql14 \
    && rm -rf /var/cache/yum

ENTRYPOINT ["/start.sh"]
