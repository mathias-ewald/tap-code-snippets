#!/bin/bash
set -euxo pipefail

ACCELERATOR_API="http://accelerator.tap.halusky.net"
ACCELERATOR_NAME="spring-sensors-rabbit"

# Download accelerator as zip file
tanzu accelerator generate $ACCELERATOR_NAME \
    --server-url $ACCELERATOR_API

# Unpack the accelerator
unzip ${ACCELERATOR_NAME}.zip

set +x
echo "##################################################################
Optional: Commit the accelerator code into you Git repository.

cd ${ACCELERATOR_NAME}
git init
git add * .gitignore .mvn
git commit -m "first commit"

git branch -M main
git remote add origin git@github.com:mathias-ewald/spring-sensors.git
git push -u origin main
##################################################################"
