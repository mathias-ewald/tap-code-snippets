#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_REPO=${INSTALL_REGISTRY_REPO}
#INSTALL_REGISTRY_USERNAME=${INSTALL_REGISTRY_USERNAME}
#INSTALL_REGISTRY_PASSWORD=${INSTALL_REGISTRY_PASSWORD}
TAP_VERSION=${TAP_VERSION:-1.1.1}

# Create namespace if not exists
kubectl create namespace tap-install --dry-run=client -o yaml | kubectl apply -f -

# Add secret and repository. Only necessary when the cluster does not already have
# access to the registry. For example, in the case of GKE and GCR this step can be
# skipped

# tanzu secret registry add tap-registry \
#   --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
#   --server ${INSTALL_REGISTRY_HOSTNAME} \
#   --export-to-all-namespaces --yes --namespace tap-install

tanzu package repository add tanzu-tap-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tap-packages:$TAP_VERSION \
  --namespace tap-install

# Validate
tanzu package repository get tanzu-tap-repository --namespace tap-install

tanzu package available list --namespace tap-install
