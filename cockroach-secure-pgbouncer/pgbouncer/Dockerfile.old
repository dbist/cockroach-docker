FROM cockroachdb/cockroach:latest-v20.2 AS base

# Need c-ares library for pgbouncer
# Installing pgbouncer from the postgresql repo
RUN rpm -ivh http://rpmfind.net/linux/centos/8.3.2011/BaseOS/x86_64/os/Packages/c-ares-1.13.0-5.el8.x86_64.rpm && \
    rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf update && \
    microdnf install \
        pgbouncer

FROM base AS pgbouncer

RUN useradd postgres

WORKDIR /etc/pgbouncer
WORKDIR /var/log/pgbouncer
WORKDIR /var/run/pgbouncer
WORKDIR /opt/pgbouncer

RUN chown -R postgres:postgres \
        /etc/pgbouncer \
        /var/log/pgbouncer \
        /var/run/pgbouncer \
        /opt/pgbouncer

WORKDIR /pgbouncer
COPY --chown=postgres "userlist.txt" "/etc/pgbouncer"
COPY --chown=postgres "entrypoint.sh" "/opt/pgbouncer"
COPY --chown=postgres "ca.cnf" "/home/postgres/ca.cnf"
COPY --chown=postgres "node.cnf" "/home/postgres/node.cnf"
COPY --chown=postgres "client.cnf" "/home/postgres/client.cnf"

RUN chmod +x /opt/pgbouncer/entrypoint.sh

EXPOSE 27000

# PGBouncer must start with a non-root user
USER postgres

WORKDIR /home/postgres
# Step 1 https://www.cockroachlabs.com/docs/v20.1/create-security-certificates-openssl
# Create a PGBouncer CA
RUN mkdir certs node_certs my-safe-directory
RUN openssl genrsa -out my-safe-directory/ca.key 2048 && \
    chmod 400 my-safe-directory/ca.key

RUN openssl req -new -x509 -config ca.cnf -key my-safe-directory/ca.key -out certs/ca.crt -days 365 -batch

RUN rm -f index.txt serial.txt && \
    touch index.txt && \
    echo '01' > serial.txt

# Create PGBouncer node certs
RUN openssl genrsa -out certs/node.key 2048 && \
    chmod 400 certs/node.key

RUN openssl req -new -config node.cnf -key certs/node.key -out node.csr -batch
RUN openssl ca -config ca.cnf -keyfile my-safe-directory/ca.key -cert certs/ca.crt -policy signing_policy -extensions signing_node_req -out certs/node.crt -outdir certs/ -in node.csr -batch
RUN mv certs/node.* node_certs/

# Create roach user cert
RUN openssl genrsa -out certs/client.roach.key 2048 && \
    chmod 400 certs/client.roach.key

RUN openssl req -new -config client.cnf -key certs/client.roach.key -out client.roach.csr -batch
RUN openssl ca -config ca.cnf -keyfile my-safe-directory/ca.key -cert certs/ca.crt -policy signing_policy -extensions signing_client_req -out certs/client.roach.crt -outdir certs/ -in client.roach.csr -batch

ENTRYPOINT ["/opt/pgbouncer/entrypoint.sh"]

# Should I copy a layer from base here?