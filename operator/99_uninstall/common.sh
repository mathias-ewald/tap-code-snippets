#!/bin/bash

function delete_images() {
  IMAGE="$1"
  for I in $(gcloud container images list-tags $IMAGE --format="get(digest)" --limit=99999999999); do
    gcloud container images delete "${IMAGE}@${I}" --force-delete-tags --quiet
  done
  for I in $(gcloud container images list --repository $IMAGE --format=json | jq '.[] | .name' -r); do
    delete_images $I
  done
}
