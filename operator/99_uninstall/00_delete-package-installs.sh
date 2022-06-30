#!/bin/bash
set -euxo pipefail

PACKAGE_NAMES="$(tanzu package installed list --namespace tap-install -o json | jq -r '.[] | .name')"
for NAME in $PACKAGE_NAMES; do
    echo "Deleting package $NAME ..."
    tanzu package installed delete $NAME --namespace tap-install --yes
done
