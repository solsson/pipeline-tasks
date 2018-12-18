# Knative Build Pipeline Tasks

We use the [Knative Local Registry](https://github.com/triggermesh/knative-local-registry) for image URLs.
Replace `knative.registry.svc.cluster.local` with your choice of registry, with necessary authentication.

[Build Pipeline](https://github.com/knative/build-pipeline) is under alpha development.
The last revision we tested with was: `f70944ea6b59295e80de9e531df5a292ceb48d43`



## Node.js Riff Runtime

[nodejs-riff-build.yaml](./nodejs-riff-build.yaml) migrated from [triggermesh/nodejs-runtime](https://github.com/triggermesh/nodejs-runtime/blob/master/knative-build-template.yaml).

```
kubectl apply -f nodejs-riff-build.yaml
kubectl apply -f nodejs-riff-example/resources.yaml
kubectl apply -f nodejs-riff-example/taskrun.yaml
```

If nothing starts, investigate `describe taskrun nodejs-riff` for validation errors, or `kubectl -n knative-build-pipeline log -l app=build-pipeline-controller --tail=10` for more details.

If the build runs but fails, see logs for the init containers. Or, because Knative Build is used under the hood, you can [access build logs](https://github.com/knative/docs/blob/master/serving/accessing-logs.md) that way too.

## Azure Runtime

[azure-build.yaml](./azure-build.yaml) migraded from [triggermesh/azure-runtime](https://github.com/triggermesh/azure-runtime/blob/master/knative-build-template.yaml).

```
kubectl apply -f azure-build.yaml
kubectl apply -f azure-example/resources.yaml
kubectl apply -f azure-example/taskrun.yaml
```

## Kaniko build caching

As soon as you intend to use your images in production we recommend build layer caching. Advantages:

 * Faster builds
 * Less space used for image registry storage
 * Faster pulls for new revisions

The advantages depend on Dockerfile design,
but anyhow we recommend that all Build tasks with Kaniko use caching.

The example uses file system caching and sets up one [pvc](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) per namespace.
This means that you can run only one build at a time per namespace,
as the build pod needs to mount the volume.

Caching between different builds is often not desirable but can have all the above advantages,
in particular if you reuse Dockerfiles.
Pay attention to the `claimName` in your runs, and edit at will.

To run the example apply a [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/)
such as [our gke example](./caching-kaniko-example/storageclassl-gke.yaml).
We recommend that you use one with `allowVolumeExpansion: true`
because you'll probably want to keep these caches long term. After that:

```
kubectl apply -f caching-kaniko-build.yaml
kubectl apply -f caching-kaniko-example/pvc.yaml
kubectl apply -f caching-kaniko-example/run.yaml
# wait for build, then re-run without deleting the pvc, see logs for the effect of caching
kubectl delete -f caching-kaniko-example/run.yaml
kubectl apply -f caching-kaniko-example/run.yaml
```

## Knative Serving Source-to-URL using Build Pipeline

With Serving [v0.2.3](https://github.com/knative/serving/releases/tag/v0.2.3) we can replace Knative Build with a TaskRun in Service objects.

Let's reuse the Node.js function example above for a complete Source-to-URL example.

```
kubectl apply -f nodejs-riff-build.yaml
kubectl apply -f nodejs-riff-example/resources.yaml
```

The TaskRun yaml can simply be copy-pasted into the Serving definition under `build:`.
We must also remember to update the `image:` in the `revisionTemplate:`
to be identical to that of our `image` resource in `resources.yaml`.

```
cat serving-build-example/service-build.yaml | grep image:
cat nodejs-riff-example/resources.yaml | grep -A 1 url
kubectl apply -f serving-build-example/service-build.yaml
kubectl describe ksvc nodejs-riff
```

Note: Out of the box Serving failed to create the build, error: `Revision creation failed with message: "taskruns.pipeline.knative.dev is forbidden: User \"system:serviceaccount:knative-serving:controller\" cannot create taskruns.pipeline.knative.dev in the namespace \"default\"".`. That can be solved by granting cluster-admin rights `kubectl create clusterrolebinding serving-controller-pipeline-build --clusterrole=cluster-admin --serviceaccount=knative-serving:controller --namespace=knative-serving` but more restricted access is probably recommended.

If the build completes and the deployment comes up, probe it using for example `kubectl run test1 --rm --image=gcr.io/cloud-builders/curl --restart=Never -ti -- -H 'Content-Type: text/plain' -d 'Build Pipeline' -w '\n' --retry 2 -v -H 'Host: nodejs-riff.default.example.com' http://knative-ingressgateway.istio-system`.

## Support

We would love your feedback on this project so don't hesitate to let us know what is wrong and how we could improve it, just file an [issue](https://github.com/triggermesh/charts/issues/new)

## Code of Conduct

This plugin is by no means part of [CNCF](https://www.cncf.io/) but we abide by its [code of conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md)
