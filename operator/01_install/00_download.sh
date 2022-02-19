#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

REFRESH_TOKEN="${REFRESH_TOKEN}"
DOWNLOAD_DIR="$SCRIPT_DIR/downloads"

# Wipe the directory
rm -fR $DOWNLOAD_DIR/*

# Authenticate with Tanzu Network
TOKEN=$(curl -s -X POST https://network.tanzu.vmware.com/api/v2/authentication/access_tokens -d "{\"refresh_token\":\"$REFRESH_TOKEN\"}" | jq .access_token -r)

# Download required files
function tanzunet_download () {
  FILE_NAME=$1
  PRODUCT_ID=$2
  RELEASE_ID=$3
  PRODUCT_FILE_ID=$4
  wget -O "$DOWNLOAD_DIR/$FILE_NAME" \
    --header="Authorization: Bearer $TOKEN"\
    https://network.tanzu.vmware.com/api/v2/products/$PRODUCT_ID/releases/$RELEASE_ID/product_files/$PRODUCT_FILE_ID/download
}

tanzunet_download tanzu-framework.tar tanzu-application-platform 1049494 1156163
tanzunet_download tanzu-cluster-essentials.tgz tanzu-cluster-essentials 1011100 1105818
