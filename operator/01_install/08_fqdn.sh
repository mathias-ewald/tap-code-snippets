#!/bin/bash
set -euo pipefail

FQDN=$(kubectl -n tap-gui get httpproxy tap-gui -o json | jq .spec.virtualhost.fqdn -r)
echo $FQDN
