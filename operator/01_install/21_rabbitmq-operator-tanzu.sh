#!/bin/bash
set -euo pipefail

exit 1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DWNLD_DIR=$SCRIPT_DIR/downloads

TANZUNET_USERNAME="${TANZUNET_USERNAME}"
TANZUNET_PASSWORD="${TANZUNET_PASSWORD}"
NAMESPACE="rabbitmq-operator"
VERSION="1.2.0"

kubectl create ns --dry-run=client -o yaml $NAMESPACE | kubectl apply -f -

kubectl create secret docker-registry regsecret \
    --namespace $NAMESPACE \
    --docker-server=https://registry.tanzu.vmware.com/ \
    --docker-username="$TANZUNET_USERNAME" \
    --docker-password="$TANZUNET_PASSWORD" \
    --dry-run=client -o yaml | kubectl apply -f -

cat <<EOF | kubectl apply -f -
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: reg-creds   
  namespace: $NAMESPACE
spec:
  toNamespaces:
  - "*" 
EOF

kubectl -n rabbitmq-operator patch serviceaccount default -p '{"ima^CPullSecrets": [{"name": "regsecret"}]}'

cat <<EOF | kubectl apply -f -
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageRepository
metadata:
  name: tanzu-rabbitmq-repo
  namespace: $NAMESPACE
spec:
  fetch:
    imgpkgBundle:
      image: registry.tanzu.vmware.com/p-rabbitmq-for-kubernetes/tanzu-rabbitmq-package-repo:${VERSION} # Replace with release version
      secretRef:
        name: regsecret
EOF



cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: tanzu-rabbitmq-values
  namespace: ${NAMESPACE}
stringData:
  values.yml: |
    ---
    namespace: ${NAMESPACE}
---
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: tanzu-rabbitmq
  namespace: ${NAMESPACE}
spec:
  serviceAccountName: default
  packageRef:
    refName: rabbitmq.tanzu.vmware.com
    versionSelection:
      constraints: ${VERSION}
  values:
  - secretRef:
      name: tanzu-rabbitmq-values
EOF
