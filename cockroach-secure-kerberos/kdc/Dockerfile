FROM alpine:3.12

LABEL maintainer="artemervits at gmail dot com"
LABEL version="2.0"
LABEL description="kerberos kdc container"
ENV REFRESHED_AT 2020_07_22

RUN apk add --no-cache \
  krb5-server \
  && rm -rf /var/cache/apk/*

COPY krb5.conf /etc/krb5.conf

RUN kdb5_util create -s -P kpass \
  && kadmin.local -q "addprinc -pw psql tester@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey postgres/roach-0@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey postgres/roach-1@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey postgres/roach-2@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey customspn/roach-0@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey customspn/roach-1@EXAMPLE.COM" \
  && kadmin.local -q "addprinc -randkey customspn/roach-2@EXAMPLE.COM"   # This is a custom SPN in case krbsrvname is required

CMD ["/start.sh"]
