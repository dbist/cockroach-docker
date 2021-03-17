# using bitnami image instead of pgbouncer because of issues mounting /certs dir
# 2021-03-17 16:55:57.496 UTC [1] FATAL TLS setup failed: failed to load private key file "/certs/client.root.key": Permission denied"

FROM bitnami/pgbouncer:1.15.0

LABEL maintainer="artemervits at gmail dot com"
LABEL version=1.0

EXPOSE 27000
