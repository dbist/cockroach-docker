# Build the test binary in a multistage build.
FROM postgres:9.5

LABEL maintainer="artemervits at gmail dot com"
LABEL version="1.0"
LABEL description="psql client container"

# installing dnsutils as we want to `nslookup` cockroach container
# vim is needed to edit /etc/hosts to add cockroach node, remove when /etc/hosts
# can be populated programmatically

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user dnsutils vim

ENTRYPOINT ["/start.sh"]
