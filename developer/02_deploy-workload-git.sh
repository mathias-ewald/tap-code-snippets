#!/bin/bash
set -euxo pipefail

NAMESPACE="mewald"
PROJECT_NAME=${PROJECT_NAME:-spring-sensors-git}

# Create workload
tanzu app workload create $PROJECT_NAME \
  --namespace $NAMESPACE \
  --git-repo ssh://git@github.com/mathias-ewald/spring-sensors \
  --git-branch main \
  --param gitops_ssh_secret=git-ssh \
  --label "apps.tanzu.vmware.com/workload-type=web" \
  --label "app.kubernetes.io/part-of=spring-sensors-git"

exit 0

URL="$(kubectl -n mewald get service.serving.knative.dev/$PROJECT_NAME -o json | jq -r '.status.url')"

echo "##################################################################
Watch Status:    tanzu app workload get --namespace $NAMESPACE $PROJECT_NAME
Tail Logs:       tanzu app workload tail --namespace $NAMESPACE $PROJECT_NAME
Observe Pods:    kubectl -n $NAMESPACE get pods
Access URL:      $URL
##################################################################"
