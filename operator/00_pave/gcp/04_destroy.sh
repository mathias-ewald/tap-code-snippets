#!/bin/bash
set -euo pipefail

source ./tf-common.sh

terraform destroy
