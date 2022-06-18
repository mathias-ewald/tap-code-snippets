#!/bin/bash
set -euo pipefail

PROJECT_ID=${PROJECT_ID}
ENVIRONMENT_NAME=${ENVIRONMENT_NAME}
REGION="${REGION}"

BUCKET_NAME="gs://tap-$ENVIRONMENT_NAME-tfstate"

set +e
gsutil ls | grep $BUCKET_NAME > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Bucket $BUCKET_NAME already exists."
else
  BUCKET_NAME="gs://tap-$ENVIRONMENT_NAME-tfstate"
  echo "Creating bucket $BUCKET_NAME"
  gsutil mb \
    -p "$PROJECT_ID" \
    -c "STANDARD" \
    -l "$REGION" \
    -b on \
    $BUCKET_NAME
fi
set -e
