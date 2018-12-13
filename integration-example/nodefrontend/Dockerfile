FROM node:10.14.2-slim@sha256:7e6741b8b25881f50c6294b907d8ee9e63c735438e4d62b96ce019050df256bf

WORKDIR /usr/src/app

#COPY package-lock.json package.json ./
#RUN npm ci

COPY package.json ./
RUN npm install --production

COPY . ./
RUN npm install

RUN npm test

ENTRYPOINT ["npm", "start"]
