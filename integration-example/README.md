# Example multi-module repository

This example is meant to demonstrate how Build Pipeline shines over the old Knative Build:
It is designed to support real CI/CD flows, not only a source-to-image happy path.

To provide sufficient complexity this folder models a repository with multiple services,
and also libraries that these services depend on.
The repsitory would be owned by a single team that likes to branch and release all of it together.

Everything is Node.js now, but we'll add a Go service as well to motivate the microservices architecture.

TODO:

 * Add a Go service + lib
 * Show how images can be pused to a production registry after test success
   - and _not_ pushed upon test failure
 * Skip integration tests (they are slow) if all built images for it are unchanged
   - and show how to force test re-run
 * Once this entire example is robust we can update the build to run directly off github, and remove the git step below.

## Running the example

As usual with Knative examples you need to sort out two things yourself:

 * How is your source accessed? - URL and possibly authentication
 * Where are images pushed and how can Docker on the nodes pull them?

Obviously you need to install Knative Build Pipeline as well,
see [examples' docs](https://github.com/knative/build-pipeline/tree/master/examples#examples) for how.

There's a script [git-apply.sh](./git-apply.sh) that together with [in-cluster Gogs](https://github.com/solsson/knative-training/tree/master/git) was used to speed up development of this demo.
It provides a good example of what is needed to run.

Also if you use [knative-local-registry](https://github.com/triggermesh/knative-local-registry/tree/builds-service)
there's no need to update any image URLs.
If you go for updating, use recursive search and replace as there are many of them.

## Expected result

Apologies for the raw format, but we'll work on stability before writing a step-by-step guide

```
$ ./git-apply.sh 
Cloning into 'gittemp'...
remote: Enumerating objects: 98, done.
remote: Counting objects: 100% (98/98), done.
remote: Compressing objects: 100% (79/79), done.
remote: Total 98 (delta 43), reused 0 (delta 0)
Unpacking objects: 100% (98/98), done.
[master 6c0c0fa] Sun Dec 16 18:21:03 CET 2018
 4 files changed, 9 insertions(+), 3 deletions(-)
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 12 threads
Compressing objects: 100% (7/7), done.
Writing objects: 100% (8/8), 850 bytes | 850.00 KiB/s, done.
Total 8 (delta 6), reused 0 (delta 0)
To http://localhost:3000/ExampleSource/integration-example.git
   a8792d7..6c0c0fa  HEAD -> master
namespace/pipelinerun-181216t172104-4c89b394 created
task.pipeline.knative.dev/build-push created
persistentvolumeclaim/kaniko-cache created
storageclass.storage.k8s.io/kaniko-cache unchanged
task.pipeline.knative.dev/caching-kaniko created
task.pipeline.knative.dev/npm-export created
task.pipeline.knative.dev/test-completion created
pipeline.pipeline.knative.dev/integration-example created
pipelineresource.pipeline.knative.dev/integration-example-git created
pipelineresource.pipeline.knative.dev/integration-example-npmlib-image created
pipelineresource.pipeline.knative.dev/integration-example-npmlib2-image created
pipelineresource.pipeline.knative.dev/integration-example-nodefrontend-image created
pipelinerun.pipeline.knative.dev/integration-example-1 created
kubectl -n pipelinerun-181216t172104-4c89b394
clusterrolebinding.rbac.authorization.k8s.io/test-pipelinerun-181216t172104-4c89b394 created
NAME                    AGE
integration-example-1   1s
NAME                                             READY   STATUS    RESTARTS   AGE
integration-example-1-export-npmlib-pod-93507b   0/1     Pending   0          0s
integration-example-1-export-npmlib-pod-93507b   0/1   Pending   0     0s
integration-example-1-export-npmlib-pod-93507b   0/1   Init:0/5   0     0s
integration-example-1-export-npmlib-pod-93507b   0/1   Init:1/5   0     1s
integration-example-1-export-npmlib-pod-93507b   0/1   Init:2/5   0     2s
integration-example-1-export-npmlib-pod-93507b   0/1   Init:3/5   0     3s
integration-example-1-export-npmlib-pod-93507b   0/1   Init:4/5   0     4s
integration-example-1-export-npmlib-pod-93507b   0/1   Init:4/5   0     5s
integration-example-1-export-npmlib-pod-93507b   0/1   PodInitializing   0     28s
integration-example-1-export-npmlib-pod-93507b   0/1   Completed   0     29s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Pending   0     0s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Pending   0     0s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Pending   0     0s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Init:0/5   0     0s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Init:1/5   0     2s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Init:2/5   0     3s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Init:3/5   0     4s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Init:4/5   0     5s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Init:4/5   0     6s
integration-example-1-export-npmlib2-pod-8373fd   0/1   PodInitializing   0     29s
integration-example-1-export-npmlib2-pod-8373fd   0/1   Completed   0     30s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Pending   0     0s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Pending   0     0s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Pending   0     0s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Init:0/4   0     0s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Init:1/4   0     2s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Init:2/4   0     3s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Init:3/4   0     4s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Init:3/4   0     6s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   PodInitializing   0     27s
integration-example-1-build-nodefrontend-pod-d7833e   0/1   Completed   0     28s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Pending   0     0s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Pending   0     0s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Pending   0     3s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Init:0/4   0     3s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Init:1/4   0     4s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Init:2/4   0     5s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Init:3/4   0     6s
testclient1   0/1   Pending   0     0s
testclient1   0/1   Pending   0     0s
nodefrontend-79b8bc489d-skh8m   0/1   Pending   0     0s
testclient1   0/1   ContainerCreating   0     0s
nodefrontend-79b8bc489d-bxmkx   0/1   Pending   0     0s
nodefrontend-79b8bc489d-skh8m   0/1   Pending   0     0s
nodefrontend-79b8bc489d-bxmkx   0/1   Pending   0     0s
nodefrontend-79b8bc489d-skh8m   0/1   ContainerCreating   0     0s
testclient2   0/1   Pending   0     0s
nodefrontend-79b8bc489d-bxmkx   0/1   ContainerCreating   0     0s
testclient2   0/1   Pending   0     0s
testclient2   0/1   ContainerCreating   0     0s
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1   Init:3/4   0     8s
testclient1   1/1   Running   0     1s
testclient2   1/1   Running   0     2s
nodefrontend-79b8bc489d-skh8m   1/1   Running   0     3s
nodefrontend-79b8bc489d-bxmkx   1/1   Running   0     4s
testclient2   0/1   Error   0     2m13s
testclient1   0/1   Error   0     2m13s
testclient2   0/1   Completed   1     2m14s

$ kubectl -n pipelinerun-181216t172104-4c89b394 get pods
NAME                                                  READY   STATUS      RESTARTS   AGE
integration-example-1-build-nodefrontend-pod-d7833e   0/1     Completed   0          9m26s
integration-example-1-export-npmlib-pod-93507b        0/1     Completed   0          11m
integration-example-1-export-npmlib2-pod-8373fd       0/1     Completed   0          10m
integration-example-1-itest-nodefrontend-pod-2a68e2   0/1     Init:3/4    0          8m26s
nodefrontend-79b8bc489d-bxmkx                         1/1     Running     0          8m19s
nodefrontend-79b8bc489d-skh8m                         1/1     Running     0          8m19s
testclient1                                           0/1     Error       0          8m19s
testclient2

$ kubectl -n pipelinerun-181216t172104-4c89b394 logs -f integration-example-1-itest-nodefrontend-pod-2a68e2 -c build-step-script
service/nodefrontend created
deployment.apps/nodefrontend created
pod/testclient1 created
pod/testclient2 created
Sun Dec 16 17:24:21 UTC 2018
testclient1  True
testclient2  True
# you might need to delete and recreate a testclient pod to make the test pass
Sun Dec 16 17:48:32 UTC 2018
All tests seem to have passed
```

We have no way to react on the test result ATM, which is why the kubectl step goes sleeping: exec into it to continue.
