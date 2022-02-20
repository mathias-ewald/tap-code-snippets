#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INSTALL_BUNDLE=${INSTALL_BUNDLE}
INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_USERNAME=${INSTALL_REGISTRY_USERNAME}
INSTALL_REGISTRY_PASSWORD=${INSTALL_REGISTRY_PASSWORD}
TAP_VERSION=${TAP_VERSION}

# Install the TAP repo
set +e
kubectl get ns tap-install > /dev/null 2>&1
RETVAL=$?
set -e
if [ $RETVAL -ne 0 ]; then 
  kubectl create ns tap-install
fi

tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces --yes --namespace tap-install

tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION \
  --namespace tap-install

tanzu package repository get tanzu-tap-repository --namespace tap-install

tanzu package available list --namespace tap-install
