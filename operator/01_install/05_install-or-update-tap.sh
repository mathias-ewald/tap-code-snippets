#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAMESPACE="tap-install"
TAP_VERSION="$TAP_VERSION"
TAP_DIR=$SCRIPT_DIR/tap
TLS_DIR=$SCRIPT_DIR/tls

# Create ClusterRoleBinding to allow PSP
# TODO: GCP specific -> Move to paving if possible
set +e
kubectl create clusterrolebinding tap-psp-rolebinding \
  --group=system:authenticated \
  --clusterrole=gce:podsecuritypolicy:privileged
set -e 

if [ ! -f $TAP_DIR/config.yaml ]; then 
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
ytt -f $TAP_DIR/values-template.yaml -f $TAP_DIR/config.yaml -f $TAP_DIR/secrets.yaml > $TAP_DIR/values.yaml

# Install or update the TAP package
ACTION="install"
if [ "$(check_install_or_upgrade)" == 'upgrade' ]; then
  ACTION="installed update"
fi

set +e
kubectl create secret generic tap-pkgi-overlay-0-cnrs-network-config \
  --namespace tap-install \
  --from-file="tap-pkgi-overlay-0-cnrs-network-config.yaml=${TLS_DIR}/tap-pkgi-overlay-0-cnrs-network-config.yaml"
set -e

tanzu package $ACTION tap \
  -p tap.tanzu.vmware.com \
  -v "$TAP_VERSION" \
  --values-file $TAP_DIR/values.yaml \
  --wait="false" \
  -n "$NAMESPACE"

kubectl annotate packageinstalls tap \
  --namespace tap-install \
  --overwrite ext.packaging.carvel.dev/ytt-paths-from-secret-name.0=tap-pkgi-overlay-0-cnrs-network-config

kubectl get packageinstalls -A

echo "##################################################################"
echo "Check \"kubectl get packageinstalls -A\" to watch progress"
echo "##################################################################"
