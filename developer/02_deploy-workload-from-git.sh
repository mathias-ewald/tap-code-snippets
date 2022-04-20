#!/bin/bash
set -euxo pipefail

ACCELERATOR_API="http://accelerator.tap.halusky.net"
ACCELERATOR_NAME="spring-sensors-rabbit"
NAMESPACE="mewald"

# Download accelerator as zip file
tanzu accelerator generate $ACCELERATOR_NAME \
    --server-url $ACCELERATOR_API

# Unpack the accelerator
unzip ${ACCELERATOR_NAME}.zip

# Create workload
tanzu app workload create $ACCELERATOR_NAME \
    --namespace $NAMESPACE \
    --local-path $ACCELERATOR_NAME \
    --source-image gcr.io/cso-pcfs-emea-mewald/local-build-stage \
    --label "apps.tanzu.vmware.com/workload-type=web" \
    --label "app.kubernetes.io/part-of=$ACCELERATOR_NAME"

echo "##################################################################
Watch Status:    tanzu app workload get --namespace $NAMESPACE $ACCELERATOR_NAME
Tail Logs:       tanzu app workload tail $ACCELERATOR_NAME
Observe Pods:    kubectl -n $NAMESPACE get pods
##################################################################"
