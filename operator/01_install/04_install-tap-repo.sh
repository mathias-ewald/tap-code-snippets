#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_REPO=${INSTALL_REGISTRY_REPO}
INSTALL_REGISTRY_USERNAME=${INSTALL_REGISTRY_USERNAME}
set +x
INSTALL_REGISTRY_PASSWORD=${INSTALL_REGISTRY_PASSWORD}
set -x
TAP_VERSION=${TAP_VERSION:-${TAP_VERSION_DEFAULT}}

# Create namespace if not exists
kubectl create namespace tap-install --dry-run=client -o yaml | kubectl apply -f -

# Add secret and repository. Only necessary when the cluster does not already have
# access to the registry. For example, in the case of GKE and GCR this step can be
# skipped

set +x
PASS_FILE=$(mktemp)
echo -n "$INSTALL_REGISTRY_PASSWORD" > $PASS_FILE
set -x

tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} \
  --password-file $PASS_FILE \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces --yes --namespace tap-install

rm $PASS_FILE

tanzu package repository add tanzu-tap-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tap-packages:$TAP_VERSION \
  --namespace tap-install

# Validate
tanzu package repository get tanzu-tap-repository --namespace tap-install

tanzu package available list --namespace tap-install
