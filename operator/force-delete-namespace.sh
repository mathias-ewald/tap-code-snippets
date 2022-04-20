#!/bin/bash
set -euxo pipefail

NAMESPACE=$1
TMPFILE=$(mktemp)

kubectl proxy &
kubectl get namespace $NAMESPACE -o json | jq '.spec = {"finalizers":[]}' > $TMPFILE

curl -k -H "Content-Type: application/json" -X PUT --data-binary @$TMPFILE 127.0.0.1:8001/api/v1/namespaces/$NAMESPACE/finalize

rm $TMPFILE
