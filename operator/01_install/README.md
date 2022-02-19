# Install

## Preparations
```
PROJECT_ID="cso-pcfs-emea-mewald"
REGION="europe-west1"
```

### Setup gcloud CLI
```
gcloud auth login
gcloud config set project $PROJECT_ID
```
### Connect To Cluster
```
gcloud container clusters get-credentials tap-cluster-demo \
  --region $REGION \
  --project $PROJECT_ID
```

### Download Assets From Tanzu Network
```
export REFRESH_TOKEN="*****************"
./00_download.sh
```

