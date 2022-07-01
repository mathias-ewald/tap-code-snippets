#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl create ns --dry-run=client -o yaml rabbitmq-system | kubectl apply -f -

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install -n rabbitmq-system rabbitmq-operator bitnami/rabbitmq-cluster-operator
