# Use the standard Cockroach image with krb5-user library
FROM cockroachdb/cockroach:latest-v22.1

LABEL maintainer="artemervits at gmail dot com"
LABEL version="5.0"
LABEL description="native cockroach client container with kerberos utilities"
ENV REFRESHED_AT 2022_06_09

RUN rpm -ivh https://rpmfind.net/linux/fedora/linux/releases/37/Everything/x86_64/os/Packages/c/c-ares-1.17.2-3.fc37.x86_64.rpm && \
    rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf update && \
    microdnf install \
    krb5-workstation \
    postgresql14 \
    && rm -rf /var/cache/yum

ENTRYPOINT ["/start.sh"]
