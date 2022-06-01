# Install

1. Download required items from Tanzu Network
```
export TANZUNET_REFRESH_TOKEN='****************'
./00_download.sh
```

2. Install Cluster Essentials (kapp-controller, carvel tools) on the cluster and the local machine
```
export TANZUNET_USERNAME="mathiase@vmware.com"
export TANZUNET_PASSWORD="**************"
./01_install-cluster-essentials.sh
```

3. Install Tanzu CLI on the local machine
```
./02_install-tanzu-cli.sh
```

4. Relocate TAP images
```
# Source
export TANZUNET_USERNAME="mathiase@vmware.com"
export TANZUNET_PASSWORD='**************'
export TAP_VERSION="1.1.0"

# Destination
export INSTALL_REGISTRY_HOSTNAME=gcr.io
export INSTALL_REGISTRY_REPO=cso-pcfs-emea-mewald

./03_relocate-images.sh
```

5. Install the TAP Repository on the K8s cluster
```
export INSTALL_REGISTRY_HOSTNAME=gcr.io
export INSTALL_REGISTRY_REPO=cso-pcfs-emea-mewald
./04_install-tap-repo.sh
```

6. Install TAP

Prepare the `secrets.yaml` file:
```
cp tap/secrets-example.yaml tap/secrets.yaml
vim tap/secrets.yaml
```

Configure the installation via `config.yaml`
```
vim tap/config.yaml
```

Install TAP
```
export TAP_VERSION="1.1.0"
./05_install-or-update-tap.sh
```

7. Get the wildcard DNS name and IP address to set up the record
```
./06_dns-records.sh
```

8. Create TLS certificates
```
./07_tls.sh
```
You can watch the progress via  `kubectl get certs -A`

9. Open your browser at
```
./08_fqdn.sh
```


# Uninstall

```
./99_uninstall.sh
```
