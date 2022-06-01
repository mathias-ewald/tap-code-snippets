#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TAP_DIR=$SCRIPT_DIR/tap
TLS_DIR=$SCRIPT_DIR/tls

# During the installation of the "tap" package, we generated a values.yaml that
# references secret of certificates that did not exist, yet. This was necessary we
# want to use cert-manager to create those certs but cert-manager is only installed as
# a dependency of the tap package. Up to this point, tap packages will be reconciling
# until the required certs and secrets have been created.

# The following code creates a ClusterIssuer that uses DNS01 challenge via CloudDNS
# (GCP) and Certificates to be used with TAP. The yaml files in the tls/ directory are
# merely templates that are rendered with the help of config.yaml and secrets.yaml.

echo "Creating ClusterIssuer"
ytt -f $TLS_DIR/cluster-issuer.yaml -f $TAP_DIR/config.yaml -f $TAP_DIR/secrets.yaml | kubectl apply -f -

echo "Creating Certificates"
ytt -f $TLS_DIR/certificate.yaml -f $TAP_DIR/config.yaml -f $TAP_DIR/secrets.yaml | kubectl apply -f -
