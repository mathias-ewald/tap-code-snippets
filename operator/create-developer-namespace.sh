#!/bin/bash
set -euxo pipefail

# Name of the developer namespace
NAMESPACE="$1"

kubectl create ns $NAMESPACE

# Values for Google Container Registry (GCR)
REGISTRY_SERVER="gcr.io"
REGISTRY_USERNAME="_json_key"
REGISTRY_PASSWORD_FILE=$GOOGLE_APPLICATION_CREDENTIALS

# Values for Git credentials
GIT_PRIVKEY="${GIT_PRIVKEY:-$HOME/.ssh/identity}"
GIT_PUBKEY="${GIT_PUBKEY:-$HOME/.ssh/identity.pub}"
GIT_KNOWNHOSTS="${GIT_KNOWNHOSTS:-$HOME/.ssh/known_hosts}"

tanzu secret registry add registry-credentials \
  --server $REGISTRY_SERVER \
  --username "$REGISTRY_USERNAME" \
  --password-file "$REGISTRY_PASSWORD_FILE" \
  --namespace "$NAMESPACE"

# ssh-keyscan github.com > /home/mathiase_vmware_com/.ssh/known_hosts
kubectl -n $NAMESPACE create secret generic git-ssh \
  --type ssh-auth \
  --from-file=ssh-privatekey=$GIT_PRIVKEY \
  --from-file=identity=$GIT_PRIVKEY \
  --from-file=identity.pub=$GIT_PUBKEY \
  --from-file=known_hosts=$GIT_KNOWNHOSTS

kubectl -n $NAMESPACE annotate secret git-ssh \
  tekton.dev/git-0="github.com"

cat <<EOF | kubectl -n "$NAMESPACE" apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: registry-credentials
  - name: tap-registry
  - name: git-ssh
imagePullSecrets:
  - name: registry-credentials
  - name: tap-registry

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: default
rules:
- apiGroups: [source.toolkit.fluxcd.io]
  resources: [gitrepositories]
  verbs: ['*']
- apiGroups: [source.apps.tanzu.vmware.com]
  resources: [imagerepositories]
  verbs: ['*']
- apiGroups: [carto.run]
  resources: [deliverables, runnables]
  verbs: ['*']
- apiGroups: [kpack.io]
  resources: [images]
  verbs: ['*']
- apiGroups: [conventions.apps.tanzu.vmware.com]
  resources: [podintents]
  verbs: ['*']
- apiGroups: [""]
  resources: ['configmaps']
  verbs: ['*']
- apiGroups: [""]
  resources: ['pods']
  verbs: ['list']
- apiGroups: [tekton.dev]
  resources: [taskruns, pipelineruns]
  verbs: ['*']
- apiGroups: [tekton.dev]
  resources: [pipelines]
  verbs: ['list']
- apiGroups: [kappctrl.k14s.io]
  resources: [apps]
  verbs: ['*']
- apiGroups: [serving.knative.dev]
  resources: ['services']
  verbs: ['*']
- apiGroups: [servicebinding.io]
  resources: ['servicebindings']
  verbs: ['*']
- apiGroups: [services.apps.tanzu.vmware.com]
  resources: ['resourceclaims']
  verbs: ['*']
- apiGroups: [scst-scan.apps.tanzu.vmware.com]
  resources: ['imagescans', 'sourcescans']
  verbs: ['*']

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: default
subjects:
  - kind: ServiceAccount
    name: default
EOF
