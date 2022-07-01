#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DWNLD_DIR=$SCRIPT_DIR/downloads

TANZUNET_USERNAME="${TANZUNET_USERNAME}"
TANZUNET_PASSWORD="${TANZUNET_PASSWORD}"

echo $TANZUNET_PASSWORD | \
helm registry login registry.tanzu.vmware.com \
 --username=$TANZUNET_USERNAME \
 --password-stdin

rm -fR $DWNLD_DIR/postgres*
helm pull oci://registry.tanzu.vmware.com/tanzu-sql-postgres/postgres-operator-chart --version v1.7.2 --untar --untardir $DWNLD_DIR

NAMESPACE="postgres-operator"
kubectl create ns --dry-run=client -o yaml $NAMESPACE | kubectl apply -f -

kubectl create secret docker-registry regsecret \
    --namespace $NAMESPACE \
    --docker-server=https://registry.tanzu.vmware.com/ \
    --docker-username="$TANZUNET_USERNAME" \
    --docker-password="$TANZUNET_PASSWORD" \
    --dry-run=client -o yaml | kubectl apply -f -

helm install -n $NAMESPACE postgres-operator $DWNLD_DIR/postgres-operator 
