FROM node:14.5

LABEL maintainer="artemervits at gmail dot com"
LABEL version="1.0"
LABEL description="nodejs application container"
ENV REFRESHED_AT 2020_07_24

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
  krb5-user \
&& rm -rf /var/lib/apt/lists/*

COPY app /app
WORKDIR /app
RUN npm install --save pg
RUN npm install async

ENTRYPOINT ["./start.sh"]
