#!/bin/bash
set -euo pipefail

PROJECT_ID=${PROJECT_ID}
ENVIRONMENT_NAME=${ENVIRONMENT_NAME}
REGION="${REGION}"
export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

export TF_VAR_region="$REGION"
export TF_VAR_project_id="$PROJECT_ID"
export TF_VAR_environment="$ENVIRONMENT_NAME"
export TF_VAR_zones="[\"${REGION}-a\", \"${REGION}-b\", \"${REGION}-c\"]"

cat <<EOF > backend.config
bucket = "tap-${ENVIRONMENT_NAME}-tfstate"
prefix = "tap-tfstate"
EOF
