# Pave Environment On GCP

## Configuration

```
export PROJECT_ID="cso-pcfs-emea-mewald"
export ENVIRONMENT_NAME="demo"
export REGION="europe-west3"
```

## Run Terraform

```
./00_prep.sh
./01_pave.sh
./02_hop.sh
```