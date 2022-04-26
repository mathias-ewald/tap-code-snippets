# Pave Environment On GCP

## Prerequisistes
- Terraform (tested with 1.1.9)
- Enable [Cloud Identity-Aware Proxy API](https://console.developers.google.com/apis/api/iap.googleapis.com/overview) in your GCP project

## Configuration

```
export PROJECT_ID="cso-pcfs-emea-mewald"
export ENVIRONMENT_NAME="demo"
export REGION="europe-west3"
export GOOGLE_APPLICATION_CREDENTIALS=/Users/mathiase/Downloads/cso-pcfs-emea-mewald-b8675a652dea.json
```

## Run Terraform

```
./00_prep.sh
./01_pave.sh
./02_hop.sh
```
