#ARG revision_ref
#FROM builds.registry.svc.cluster.local/integration-example/nodelib:${revision_ref} as knative-pipeline-tasks-example-nodelib
# Argh... ARG isn't working
FROM builds.registry.svc.cluster.local/integration-example/nodelib as knative-pipeline-tasks-example-nodelib
FROM builds.registry.svc.cluster.local/integration-example/nodelib2 as knative-pipeline-tasks-example-nodelib2

# Kaniko doesn't support tag+digest
#FROM node:10.14.2-slim@sha256:7e6741b8b25881f50c6294b907d8ee9e63c735438e4d62b96ce019050df256bf
# Got: WARN[0000] Error while retrieving image from cache: geting file info: stat /cache/sha256:7e6741b8b25881f50c6294b907d8ee9e63c735438e4d62b96ce019050df256bf: no such file or directory
#FROM node@sha256:7e6741b8b25881f50c6294b907d8ee9e63c735438e4d62b96ce019050df256bf
FROM node:10.14.2-slim

WORKDIR /usr/src/app

COPY --from=knative-pipeline-tasks-example-nodelib /exports/package node_modules/knative-pipeline-tasks-example-nodelib
COPY --from=knative-pipeline-tasks-example-nodelib2 /exports/package node_modules/knative-pipeline-tasks-example-nodelib2

RUN ls -l node_modules/
RUN ls -l node_modules/knative-pipeline-tasks-example-nodelib/
RUN ls -l node_modules/knative-pipeline-tasks-example-nodelib2/

#COPY package-lock.json package.json ./
#RUN npm ci

COPY package.json ./
RUN npm install --production

COPY . ./
RUN npm install

RUN npm test

ENTRYPOINT ["npm", "start"]
