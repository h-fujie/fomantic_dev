FROM node:23.7-slim

WORKDIR /usr/src/app

COPY gen/out/nodejs-server/package*.json ./

RUN npm install
RUN npm install cors --save
COPY gen/out/nodejs-server .

# CORS対策
RUN sed -i -r 's/^(\s*const express = .*)$/\1\nconst cors = require("cors");/' ./node_modules/oas3-tools/dist/middleware/express.app.config.js
RUN sed -i -r 's/^(\s*this.app = .*)$/\1\n        this.app.use(cors());/' ./node_modules/oas3-tools/dist/middleware/express.app.config.js

EXPOSE 8080
CMD [ "node", "index.js" ]
