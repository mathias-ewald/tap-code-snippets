#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAMESPACE="tap-install"
TAP_VERSION="$TAP_VERSION"

# Create ClusterRoleBinding to allow PSP
set +e
kubectl create clusterrolebinding tap-psp-rolebinding \
  --group=system:authenticated \
  --clusterrole=gce:podsecuritypolicy:privileged
set -e 

if [ ! -f $SCRIPT_DIR/config.yaml ]; then 
  echo "File config.yaml does not exist. Copy from config-extample.yaml and modify for your environment."
  exit 1
fi 

function check_install_or_upgrade () {
    OUTPUT="$(tanzu package installed get -n "$NAMESPACE" tap 2>&1)"
    if echo "$OUTPUT" | grep 'does not exist in namespace'; then
      echo "install"
      return
    fi 
    echo "upgrade"
}

# Generate the final values.yaml for the TAP package
ytt -f values-template.yaml -f config.yaml -f secrets.yaml > values.yaml

# Install or update the TAP package
ACTION="install"
if [ "$(check_install_or_upgrade)" == 'upgrade' ]; then
  ACTION="installed update"
fi

tanzu package $ACTION tap \
  -p tap.tanzu.vmware.com \
  -v "$TAP_VERSION" \
  --values-file values.yaml \
  --wait="false" \
  -n "$NAMESPACE"

echo "##################################################################"
echo "Check \"kubectl get packageinstalls -A\" to watch progress"
echo "##################################################################"
