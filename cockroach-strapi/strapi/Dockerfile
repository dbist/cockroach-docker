FROM strapi/base
LABEL maintainer="generic13 at gmail dot com"
LABEL version="0.1"
ENV REFRESHED_AT 2020_03_30
WORKDIR /src
COPY ./package.json ./
COPY ./yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build
EXPOSE 1337
ENV NODE_ENV production
CMD ["yarn", "start"]
