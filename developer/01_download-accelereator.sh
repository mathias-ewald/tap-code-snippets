#!/bin/bash
set -euxo pipefail

ACCELERATOR_API="https://accelerator.tap.halusky.net"
ACCELERATOR_NAME="tanzu-java-web-app"

# Download accelerator as zip file
tanzu accelerator generate $ACCELERATOR_NAME \
    --server-url $ACCELERATOR_API

# Unpack the accelerator
unzip ${ACCELERATOR_NAME}.zip
