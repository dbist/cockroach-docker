FROM alpine:3

LABEL maintainer="artemervits at gmail dot com"
LABEL version="3.0"
LABEL description="kerberos kdc container"
ENV REFRESHED_AT 2021_11_15

RUN apk add --no-cache \
  krb5-server \
  && rm -rf /var/cache/apk/*

COPY krb5.conf /etc/krb5.conf

# including postgres/cockroach for backwards compatibility with README
# only SPN for LB is necessary in our case
RUN kdb5_util create -s -P kpass \
  && kadmin.local -q "addprinc -pw psql tester@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey postgres/cockroach@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey postgres/lb@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey customspn/cockroach@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey customspn/lb@EXAMPLE.COM"   # This is a custom SPN in case krbsrvname is required

CMD ["/start.sh"]
