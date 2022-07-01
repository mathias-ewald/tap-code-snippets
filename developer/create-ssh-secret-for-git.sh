#!/bin/bash
set -euo pipefail

IDENTITY=${1}
NAMESPACE=${NAMESPACE}
GIT_HOST=${GIT_HOST:-github.com}

IDENTITY_B64=""
if [ -f $IDENTITY ]; then
  IDENTITY_B64=$(cat $IDENTITY | base64 -w0)
else
  IDENTITY_B64=$(echo $IDENTITY | base64 -w0)
fi
KNOWN_HOSTS_B64="$(ssh-keyscan $GITHOST 2> /dev/null | base64 -w0)"


cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: ssh-credentials
  namespace: $NAMESPACE
type: Opaque
data:
  identity: $IDENTITY_B64
  known_hosts: $KNOWN_HOSTS_B64
EOF

echo "#################################################################################"
echo "Secret \"ssh-credentials\" has been created in namespace $NAMESPACE"
echo "In your workload.yaml, set the following to use it:"
echo ""
echo "spec:"
echo "  params:"
echo "  - name: gitops_ssh_secret"
echo "    value: ssh-credentials"
echo "  source:"
echo "    git:"
echo "      url: ssh://user@example.com:22/repository.git"
echo "#################################################################################"

