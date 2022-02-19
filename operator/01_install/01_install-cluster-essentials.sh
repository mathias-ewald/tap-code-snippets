#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INSTALL_BUNDLE=${INSTALL_BUNDLE}
INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_USERNAME=${INSTALL_REGISTRY_USERNAME}
INSTALL_REGISTRY_PASSWORD=${INSTALL_REGISTRY_PASSWORD}
DOWNLOADS_DIR="$SCRIPT_DIR/downloads"

# Check if Tanzu Cluster Essentials bundle is available
FILE_PATH="$DOWNLOADS_DIR/tanzu-cluster-essentials.tgz"
if [ ! -f $FILE_PATH ]; then
    echo "Download file $FILE_NAME from Tanzu Network and run again."
fi

# Extract Tanzu Cluster Essentials
CLUSTER_ESSENTIALS_DIR=$DOWNLOADS_DIR/tanzu-cluster-essentials
if [ -d $CLUSTER_ESSENTIALS_DIR ]; then
  rm -fR $CLUSTER_ESSENTIALS_DIR
fi
mkdir $CLUSTER_ESSENTIALS_DIR
tar xvf $FILE_PATH -C $CLUSTER_ESSENTIALS_DIR > /dev/null 2>&1

# Install kapp CLI
if [ ! -f /usr/local/bin/kapp ]; then
  sudo cp $CLUSTER_ESSENTIALS_DIR/kapp /usr/local/bin/kapp
fi

# Validate environment variables are set
ALL_GOOD="yes"
for I in INSTALL_BUNDLE INSTALL_REGISTRY_HOSTNAME INSTALL_REGISTRY_USERNAME INSTALL_REGISTRY_PASSWORD; do
    env | grep "$I="
    if [ "$?" -ne 0 ]; then
        echo "Variable $I is not set or not exported."
        ALL_GOOD="no"
    fi
done
if [ $ALL_GOOD != "yes" ]; then exit 1; fi

# Install Tanzu Cluster Essentials
pushd $CLUSTER_ESSENTIALS_DIR
  ./install.sh
popd