# Build the test binary in a multistage build.
FROM postgres:11

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user dnsutils vim

ENTRYPOINT ["/start.sh"]
