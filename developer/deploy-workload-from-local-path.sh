#!/bin/bash
set -euxo pipefail

ACCELERATOR_API="accelerator.tap.halusky.net"
ACCELERATOR_NAME="spring-sensors-rabbit"

PROJECT_NAME="myapp"
PROJECT_GITREPO="git@github.com/mathias-ewald/myapp"
PROJECT_GITBRANCH="main"

# Download accelerator as zip file
tanzu accelerator generate $ACCELERATOR_NAME \
    --server-url $ACCELERATOR_API \
    --options='{"gitUrl": "'"$PROJECT_GITREPO"'","gitBranch": "'"$PROJECT_GITBRANCH"'"}'

# Unpack the accelerator
unzip ${ACCELERATOR_NAME}.zip

# Create workload
tanzu app workload create $PROJECT_NAME \
    --local-path $ACCELERATOR_NAME \
    --source-image gcr.io/cso-pcfs-emea-mewald/local-build-stage \
    --label "apps.tanzu.vmware.com/workload-type=web"

echo "##################################################################
Watch Status:    tanzu app workload get --namespace $NAMESPACE $PROJECT_NAME
Tail Logs:       tanzu app workload tail $PROJECT_NAME
Observe Pods:    kubectl -n $NAMESPACE get pods
##################################################################"