#!/bin/bash
set -euxo pipefail

ACCELERATOR_API="http://accelerator.tap.halusky.net"
ACCELERATOR_NAME="spring-sensors-rabbit"

# Download accelerator as zip file
tanzu accelerator generate $ACCELERATOR_NAME \
    --server-url $ACCELERATOR_API

# Unpack the accelerator
unzip ${ACCELERATOR_NAME}.zip
