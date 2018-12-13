# Inline shell script task

Sometimes you just need a build step that runs a few shell commands,
and you don't feel like building an image for it.

This example only produces stdout, so use `kubectl logs -c build-step-script inline-script-pod-[suffix]`
