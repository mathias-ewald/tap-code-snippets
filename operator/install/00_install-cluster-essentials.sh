#!/bin/bash

VERSION="1.0.0"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Check if Tanzu Cluster Essentials bundle is available
FILE_NAME="tanzu-cluster-essentials-$(uname -s | tr '[:upper:]' '[:lower:]')-amd64-${VERSION}.tgz"
FILE_PATH="$SCRIPT_DIR/$FILE_NAME"
if [ ! -f $FILE_PATH ]; then
    echo "Download file $FILE_NAME from Tanzu Network and run again."
fi

# Extract Tanzu Cluster Essentials
CLUSTER_ESSENTIALS_DIR=$SCRIPT_DIR/tanzu-cluster-essentials
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