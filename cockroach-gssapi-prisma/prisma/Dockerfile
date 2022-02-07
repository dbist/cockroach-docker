FROM node
LABEL maintainer="artemervits at gmail dot com"
LABEL version="0.1"
LABEL description="prisma client container"
ENV REFRESHED_AT 2022_02_07

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user \
  && rm -rf /var/lib/apt/lists/*

COPY ./cockroachdb /cockroachdb/
WORKDIR /cockroachdb
RUN npm install

# TODO: use builder and copy cockroach binary into node image

RUN curl https://binaries.cockroachdb.com/cockroach-v21.2.5.linux-amd64.tgz | tar -xz && cp -i cockroach-v21.2.5.linux-amd64/cockroach /usr/local/bin/
RUN mkdir -p /usr/local/lib/cockroach && \
 cp -i cockroach-v21.2.5.linux-amd64/lib/libgeos.so /usr/local/lib/cockroach/ && \
 cp -i cockroach-v21.2.5.linux-amd64/lib/libgeos_c.so /usr/local/lib/cockroach/
COPY .env .
COPY start.sh .
ENTRYPOINT ["./start.sh"]
