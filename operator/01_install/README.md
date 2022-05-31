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

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:ab0a3539da241a6ea59c75c0743e9058511d7c56312ea3906178ec0f3491f51d
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME="$TANZUNET_USERNAME"
export INSTALL_REGISTRY_PASSWORD="$TANZUNET_PASSWORD"
export TAP_VERSION="1.1.0"

./01_install-cluster-essentials.sh
./02_install-tanzu-cli.sh
./03_install-tap-repo.sh
./04_install-or-update-tap.sh
./05_dns-records.sh
./06_tls.sh
```

```
watch kubectl get packageinstalls -A
```

# Uninstall

```
./99_uninstall.sh
```
