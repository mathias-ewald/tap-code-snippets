# Install

Set up environment variables needed along the process:
```
PROJECT_ID="cso-pcfs-emea-mewald"
REGION="europe-west3"

TANZUNET_USERNAME="mathiase@vmware.com"
TANZUNET_PASSWORD="**************"
```

```
export REFRESH_TOKEN="*****************"
./00_download.sh

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME="$TANZUNET_USERNAME"
export INSTALL_REGISTRY_PASSWORD="$TANZUNET_PASSWORD"
export TAP_VERSION="1.0.1"

./01_install-cluster-essentials.sh
./02_install-tanzu-cli.sh
./03_install-tap-repo.sh
./04_install-or-update-tap.sh
```

```
watch kubectl get packageinstalls -A
```
