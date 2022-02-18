#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Validate environment variables are set
ALL_GOOD="yes"
for I in INSTALL_BUNDLE INSTALL_REGISTRY_HOSTNAME INSTALL_REGISTRY_USERNAME INSTALL_REGISTRY_PASSWORD TAP_VERSION; do
    env | grep "$I="
    if [ "$?" -ne 0 ]; then
        echo "Variable $I is not set or not exported."
        ALL_GOOD="no"
    fi
done
if [ $ALL_GOOD != "yes" ]; then exit 1; fi


# Install the TAP repo
kubectl create ns tap-install

tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces --yes --namespace tap-install

tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION \
  --namespace tap-install

tanzu package repository get tanzu-tap-repository --namespace tap-install

tanzu package available list --namespace tap-install