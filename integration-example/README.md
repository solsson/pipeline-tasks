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
 * We currently have a good example of flaky integration tests, with curl sometimes failing to connect to the service-under-test. Let's make that robust furst and only later introduce flakyness.
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
