#!/bin/bash
set -euxo pipefail 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

TANZUNET_USERNAME=${TANZUNET_USERNAME}
TANZUNET_PASSWORD=${TANZUNET_PASSWORD}

TAP_VERSION=${TAP_VERSION:-${TAP_VERSION_DEFAULT}}

INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_REPO=${INSTALL_REGISTRY_REPO}

# We don't want imgpkg to try and use the VM's service account
export IMGPKG_ENABLE_IAAS_AUTH=false

docker login registry.tanzu.vmware.com -u $TANZUNET_USERNAME -p $TANZUNET_PASSWORD

imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:ab0a3539da241a6ea59c75c0743e9058511d7c56312ea3906178ec0f3491f51d \
  --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/cluster-essentials-bundle \
  --include-non-distributable-layers

imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tap-packages \
  --include-non-distributable-layers
