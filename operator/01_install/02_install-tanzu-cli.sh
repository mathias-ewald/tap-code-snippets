#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Check if Tanzu Frameswork bundle is available
FILE_NAME="tanzu-framework--$(uname -s | tr '[:upper:]' '[:lower:]')-amd64.tar"
FILE_PATH="$SCRIPT_DIR/$FILE_NAME"
if [ ! -f $FILE_PATH ]; then
    echo "Download file $FILE_NAME from Tanzu Network and run again."
fi

# Extract Tanzu Framework
FRAMEWORK_DIR=$SCRIPT_DIR/tanzu-framework
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