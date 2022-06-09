FROM ruby:2-alpine

RUN apk add --update --no-cache \
   libpq \
   binutils-gold \
   build-base \
   curl \
   file \
   g++ \
   gcc \
   git \
   less \
   libstdc++ \
   libffi-dev \
   libc-dev \
   linux-headers \
   libxml2-dev \
   libxslt-dev \
   libgcrypt-dev \
   make \
   netcat-openbsd \
   postgresql-dev \
   tzdata

WORKDIR /rails
COPY Gemfile Gemfile.lock ./
RUN gem install bundler pg
RUN bundle config --local build.pg --with-opt-dir="/usr/local/opt/libpq"
RUN bundle install
COPY . ./
ENTRYPOINT ["./rails/docker-entrypoint.sh"]
