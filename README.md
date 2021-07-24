# Tekton operator raw manifests

## Why?

If you need to install tekton operator https://github.com/tektoncd/operator with
a gitops like mechanism (ex: Flux) there is no official helm chart or valid raw
k8s manifests.

This repo contains a ci flow that produce, update and tag any new tekton
operator version in raw k8s yaml files.

## How it works?

* Check if new operator version is present
* Download the official manifest and split them by kind and name
* Commit the changes and tag a new release in this repo

See [new-release](./hack/new-release.sh) and [github-ci](.github/workflows/check-and-push-update.yaml)

## How to use it with Flux

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: GitRepository
metadata:
  name: tekton-operator-raw
  namespace: flux-system
spec:
  interval: 10m
  url: https://github.com/brokenpip3/tekton-operator-raw-manifests
  ref:
    tag: v0.23.0-2
  ignore: |
    .github/
    hack/
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta1
kind: Kustomization
metadata:
  name: tekton-operator-raw
  namespace: flux-system
spec:
  interval: 10m
  path: ./deploy
  prune: true
  sourceRef:
    kind: GitRepository
    name: tekton-operator-raw
  timeout: 2m0s
  validation: client
...
```

Disclaimer: I encourage you to fork this repo instead of using it this a
source of truth, never trust anyone.
