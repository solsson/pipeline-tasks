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

This example uses [an image registry as cache](https://github.com/GoogleContainerTools/kaniko/tree/v0.7.0#--cache-repo) because volumes are impractical (possibly less so if you have [ReadWriteMany](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) and volumes mountable in all availability zones).
Using [knative-local-registry]() we've added a dedicated service `kanikocache.registry.svc.cluster.local` but any registry should be ok.

```
kubectl apply -f caching-kaniko-build.yaml
kubectl apply -f caching-kaniko-example/run.yaml
# wait for build, then re-run
kubectl delete -f caching-kaniko-example/run.yaml
kubectl apply -f caching-kaniko-example/run.yaml
```

## Support

We would love your feedback on this project so don't hesitate to let us know what is wrong and how we could improve it, just file an [issue](https://github.com/triggermesh/charts/issues/new)

## Code of Conduct

This plugin is by no means part of [CNCF](https://www.cncf.io/) but we abide by its [code of conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md)
