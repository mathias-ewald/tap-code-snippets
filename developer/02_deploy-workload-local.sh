#!/bin/bash
set -euxo pipefail

NAMESPACE="mewald"
PROJECT_NAME="${1:-spring-sensors-rabbit}"
PROJECT_PATH="${2:-spring-sensors-rabbit}"

# Create workload
tanzu app workload create $PROJECT_NAME \
    --namespace $NAMESPACE \
    --local-path $PROJECT_NAME \
    --source-image gcr.io/cso-pcfs-emea-mewald/local-build-stage \
    --label "apps.tanzu.vmware.com/workload-type=web" \
    --label "app.kubernetes.io/part-of=$PROJECT_NAME"

echo "##################################################################
Watch Status:    tanzu app workload get --namespace $NAMESPACE $PROJECT_NAME
Tail Logs:       tanzu app workload tail --namespace $NAMESPACE $PROJECT_NAME
Observe Pods:    kubectl -n $NAMESPACE get pods
##################################################################"
