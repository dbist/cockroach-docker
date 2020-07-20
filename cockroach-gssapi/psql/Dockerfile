# Build the test binary in a multistage build.
FROM postgres:9.5

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user

ENTRYPOINT ["/start.sh"]
