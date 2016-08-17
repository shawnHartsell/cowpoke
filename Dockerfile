FROM mhart/alpine-node:6
MAINTAINER Alex Robson <asrobson@gmail.com>

RUN apk add --update bash

ADD . /app
ENV NODE_ENV=production

WORKDIR /app

CMD [ "node", "./src/index.js" ]
