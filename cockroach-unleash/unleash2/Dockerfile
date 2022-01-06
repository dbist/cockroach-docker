FROM node:alpine

WORKDIR .

#RUN npm init
COPY package.json .
RUN npm install unleash-server --save

COPY server.js .
# RUN node server.js

