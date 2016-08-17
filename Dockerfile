FROM node:6-slim
MAINTAINER Team Star-Lord

RUN apt-get update && \
    apt-get install -y jq bash curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD ./config.defaults.json /app/config.defaults.json
ADD ./node_modules /app/node_modules
ADD ./src /app/src
ADD ./resource /app/resource

ENV NODE_ENV=production

WORKDIR /app

CMD [ "node", "./src/index.js" ]
