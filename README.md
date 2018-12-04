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
