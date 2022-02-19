#!/bin/bash

JUMPBOX_NAME="$(terraform output -raw jumphost_name)"
JUMPBOX_ZONE="$(terraform output -raw jumphost_zone)"

gcloud compute ssh $JUMPBOX_NAME \
  --zone=$JUMPBOX_ZONE \
  --tunnel-through-iap \
  --ssh-flag="-A"
