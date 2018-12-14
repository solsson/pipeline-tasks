FROM node:10.14.2-slim@sha256:7e6741b8b25881f50c6294b907d8ee9e63c735438e4d62b96ce019050df256bf
RUN mkdir -p /exports/package
WORKDIR /usr/src/app
COPY package*.json .
RUN pwd
RUN npm install --production
RUN cp -r node_modules /exports/package/
COPY . .
RUN npm install
RUN npm test
RUN npm pack
RUN cp *.tgz /exports/
RUN cd /exports/ && tar xvzf *.tgz
RUN du -sh /exports/*
RUN du -sh /exports/package/*
FROM scratch
COPY --from=0 /exports /exports
