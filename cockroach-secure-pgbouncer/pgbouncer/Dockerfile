FROM pgbouncer/pgbouncer:1.15.0 AS base

USER postgres

WORKDIR /pgbouncer
COPY --chown=postgres "userlist.txt" "/etc/pgbouncer"
COPY --chown=postgres "ca.cnf" "/tmp/ca.cnf"
COPY --chown=postgres "node.cnf" "/tmp/node.cnf"
COPY --chown=postgres "client.cnf" "/tmp/client.cnf"

WORKDIR /tmp
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

RUN rm -rf /tmp/certs/*.pem

FROM base as pgbouncer

USER postgres

COPY --from=base --chown=postgres ["/tmp/certs", "/home/postgres/certs"]
COPY --from=base --chown=postgres ["/tmp/node_certs", "/home/postgres/node_certs"]
COPY --from=base --chown=postgres ["/tmp/my-safe-directory", "/home/postgres/my-safe-directory"]
COPY --from=base --chown=postgres ["/opt/pgbouncer", "/opt/pgbouncer"]
#COPY --chown=postgres ["/opt/pgbouncer/entrypoint.sh", "/opt/pgbouncer"]
#RUN chmod +x /opt/pgbouncer/entrypoint.sh

EXPOSE 27000
WORKDIR /opt/pgbouncer
ENTRYPOINT ["/opt/pgbouncer/entrypoint.sh"]
