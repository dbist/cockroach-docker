FROM cockroachdb/cockroach:latest-v20.2 AS base

# Need c-ares library for pgbouncer
# Installing pgbouncer from the postgresql repo
RUN rpm -ivh http://rpmfind.net/linux/centos/8.3.2011/BaseOS/x86_64/os/Packages/c-ares-1.13.0-5.el8.x86_64.rpm && \
    rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf update && \
    microdnf install \
        pgbouncer \
        postgresql95

RUN useradd cockroach

WORKDIR /etc/pgbouncer
WORKDIR /var/log/pgbouncer
WORKDIR /var/run/pgbouncer
WORKDIR /opt/pgbouncer

RUN chown -R cockroach:cockroach \
        /etc/pgbouncer \
        /var/log/pgbouncer \
        /var/run/pgbouncer \
        /opt/pgbouncer

WORKDIR /pgbouncer
COPY --chown=cockroach "userlist.txt" "/etc/pgbouncer"
COPY --chown=cockroach "entrypoint.sh" "/opt/pgbouncer"

RUN chmod +x /opt/pgbouncer/entrypoint.sh

EXPOSE 27000

# PGBouncer must start with a non-root user
USER cockroach

WORKDIR /opt/pgbouncer
#RUN mkdir certs

# Create a PGBouncer CA, doesn't work, need to  mount /certs volume first
#RUN cockroach cert create-ca --certs-dir=certs --ca-key=/certs/ca.key --allow-ca-key-reuse

# Fails to run with permission error still
ENTRYPOINT ["/opt/pgbouncer/entrypoint.sh"]

