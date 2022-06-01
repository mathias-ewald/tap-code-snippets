#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TAP_DIR=$SCRIPT_DIR/tap

ADDRESS="$(kubectl -n tanzu-system-ingress get svc envoy -o json | jq ".status.loadBalancer.ingress[] | .ip" -r)"
DOMAIN="$(cat $TAP_DIR/config.yaml | yq eval '.domain' -)"

echo "Add the following DNS record to your zone:"
echo "*.$DOMAIN => $ADDRESS"
