#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOWNLOAD_DIR="$SCRIPT_DIR/downloads"

# Check if Tanzu Frameswork bundle is available
FILE_PATH="$DOWNLOAD_DIR/tanzu-framework.tar"
if [ ! -f $FILE_PATH ]; then
  echo "Download file $FILE_PATH from Tanzu Network and run again."
fi

# Extract Tanzu Framework
FRAMEWORK_DIR=$DOWNLOAD_DIR/tanzu-framework
if [ -d $FRAMEWORK_DIR ]; then
  rm -fR $FRAMEWORK_DIR
fi
mkdir $FRAMEWORK_DIR
tar xvf $FILE_PATH -C $FRAMEWORK_DIR > /dev/null 2>&1

# Install Tanzu Framework
export TANZU_CLI_NO_INIT=true
pushd $FRAMEWORK_DIR
  sudo install cli/core/v0.11.1/tanzu-core-linux_amd64 /usr/local/bin/tanzu
  tanzu version
  tanzu plugin install --local cli all
  tanzu plugin list
popd
