#!/bin/bash
set -euxo pipefail

NAMESPACE="${NAMESPACE:-mewald}"
ACCELERATOR_NAME="spring-sensors-rabbit"
PROJECT_NAME="spring-sensors"

# Create workload
tanzu app workload create $PROJECT_NAME \
    --namespace $NAMESPACE \
    --local-path $ACCELERATOR_NAME \
    --source-image gcr.io/cso-pcfs-emea-mewald/local-build-stage \
    --label "apps.tanzu.vmware.com/workload-type=web" \
    --label "app.kubernetes.io/part-of=spring-sensors" \
    --yes

set +x
echo "##################################################################
Watch Status:    tanzu app workload get --namespace $NAMESPACE $PROJECT_NAME
Tail Logs:       tanzu app workload tail $PROJECT_NAME
Observe Pods:    kubectl -n $NAMESPACE get pods
##################################################################"
