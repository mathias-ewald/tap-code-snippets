#!/bin/bash
set -euxo pipefail

NAME=$1
NAMESPACE=${NAMESPACE}


RESOURCE_NAME="$NAME-$NAMESPACE-rmq"
cat <<EOF | kubectl apply -f -
---
apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: $RESOURCE_NAME
  namespace: service-instances
  labels:
    consumerNamespace: $NAMESPACE
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaimPolicy
metadata:
  name: rabbitmqcluster-cross-namespace
  namespace: service-instances
spec:
  consumingNamespaces:
  - '*'
  subject:
    group: rabbitmq.com
    kind: RabbitmqCluster
    selector:
      matchLabels:
        consumerNamespace: $NAMESPACE
EOF
