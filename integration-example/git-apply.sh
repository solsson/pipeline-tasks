#!/bin/bash
set -e

# see https://github.com/solsson/knative-training/commit/f205b0540839801e3e93f580ae4458cd826e0bad
# kubectl -n git port-forward gogs-0 3000
GITHOST=http://localhost:3000/

GITREPO=ExampleSource/integration-example.git

[ -e ./.git ] && echo ".git already exists here" && exit 1
[ -e ./gittemp ] && echo "gittemp already exists here" && exit 2

git clone -n "$GITHOST$GITREPO" gittemp
mv gittemp/.git ./.git && rmdir gittemp
git config user.email "knative@example.com"
git config user.name "Knative Training"
date >> pushevenifunchanged.log
git add --no-warn-embedded-repo .
git commit -m "$(date)"
rm pushevenifunchanged.log
git push origin HEAD
GITREV=$(git rev-parse HEAD)
rm -rf ./.git

#cat service-build.yaml | sed "s/revision: master/revision: $GITREV/" | kubectl apply -f -

# Can we use k8s' generateName from kubectl
namespace=pipelinerun-$(date -u "+%y%m%dt%H%M%S")-$(openssl rand -hex 4)

kubectl create namespace $namespace
kubectl -n $namespace apply -f ../caching-kaniko-build.yaml
kubectl -n $namespace apply -f ../npm-export.yaml
kubectl -n $namespace apply -f ./pipeline.yaml
kubectl -n $namespace apply -f ./pipeline-resources.yaml
kubectl -n $namespace apply -f ./pipeline-run.yaml
namespace="$namespace"
echo "kubectl -n $namespace"
kubectl -n $namespace get pods -w
