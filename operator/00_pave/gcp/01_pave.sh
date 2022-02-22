#!/bin/bash
set -euo pipefail

source ./tf-common.sh

terraform init -backend-config=backend.config
terraform apply
