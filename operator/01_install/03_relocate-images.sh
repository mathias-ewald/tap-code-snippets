#!/bin/bash
set -euxo pipefail 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TANZUNET_USERNAME=${TANZUNET_USERNAME}
TANZUNET_PASSWORD=${TANZUNET_PASSWORD}

TAP_VERSION=${TAP_VERSION}

INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_REPO=${INSTALL_REGISTRY_REPO}

# Must be there for gcloud credential helper to work
GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}
# We don't want imgpkg to try and use the VM's service account
export IMGPKG_ENABLE_IAAS_AUTH=false

docker login registry.tanzu.vmware.com -u $TANZUNET_USERNAME -p $TANZUNET_PASSWORD

imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tap-packages
