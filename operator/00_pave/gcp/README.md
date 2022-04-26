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
**Choose something unique for `ENVIRONMENT_NAME`**

## Run Terraform

```
./00_prep.sh
./01_pave.sh
./02_hop.sh
```

**Note:** If you forked this repo, you will probably want to have your SSH key available in the jumphost session. The `02_hop.sh` script will invoke `ssh` with the `-A` which enables ssh-agent forwarding. Make sure to add your SSH key to your local `ssh-agent` before hopping:

```
➜  ~ ssh-add -l
The agent has no identities.
➜  ~ ssh-add .ssh/id_rsa
Identity added: .ssh/id_rsa (mathiase@mathiase-a02.vmware.com)
➜  ~ ssh-add -l
3072 SHA256:K9dp3e0Q++jIbRlyoE137JuWMuIMVdGx7bLCeC0gAtA mathiase@mathiase-a02.vmware.com (RSA)
➜  ~
```
