#!/bin/bash
set -euo pipefail

PROJECT_ID="cso-pcfs-emea-mewald"
REGION="europe-west3"

gcloud auth login
gcloud config set project $PROJECT_ID

gcloud container clusters get-credentials tap-cluster-demo \
  --region $REGION \
  --project $PROJECT_ID


