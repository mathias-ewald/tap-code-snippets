#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ADDRESS="$(kubectl -n tanzu-system-ingress get svc envoy -o json | jq ".status.loadBalancer.ingress[] | .ip" -r)"
DOMAIN="$(cat $SCRIPT_DIR/config.yaml | yq eval '.domain' -)"

echo "*.$DOMAIN => $ADDRESS"
