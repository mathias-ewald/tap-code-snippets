#!/bin/bash
set -euxo pipefail

PROJECT_ID=${PROJECT_ID}

PACKAGE_NAMES="$(tanzu package installed list --namespace tap-install -o json | jq -r '.[] | .name')"
for NAME in $PACKAGE_NAMES; do
    echo "Deleting package $NAME ..."
    tanzu package installed delete $NAME --namespace tap-install --yes
done


for REPO in build-service local-build-stage supply-chain; do
  for I in $(gcloud container images list-tags gcr.io/$PROJECT_ID/$REPO --format="get(digest)" --limit=99999999999); do
    gcloud container images delete "gcr.io/$PROJECT_ID/$REPO@$I" --force-delete-tags --quiet
  done
done
