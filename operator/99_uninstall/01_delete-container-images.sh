#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PROJECT_ID=${PROJECT_ID}
EXCLUDED="tap-packages"

source $SCRIPT_DIR/common.sh

IMAGES=$(gcloud container images list --format=json | jq '.[] | .name' -r)

for IMAGE in $IMAGES; do 
  NAME=$(echo $IMAGE | rev | cut -d '/' -f 1 | rev)
  if echo $EXCLUDED | grep $NAME; then
    continue
  fi
  delete_images $IMAGE

done 
