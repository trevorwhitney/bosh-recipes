#!/bin/bash

set -ex

if [ $# -ne 1 ]; then 
  echo "Invalid usage: $0 admin_username"
  exit 1
fi

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

if [ ! -e ~/.ssh/bosh ]; then
  ssh-keygen -t rsa -f ~/.ssh/bosh -C bosh -N ''
  gcloud compute project-info add-metadata --metadata-from-file \
    sshKeys=<( gcloud compute project-info describe --format=json | jq -r '.commonInstanceMetadata.items[] | select(.key == "sshKeys") | .value' & echo "bosh:$(cat ~/.ssh/bosh.pub)"  )
fi

export admin_username=$1
export service_account=bosh-user
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com
mkdir -p ${privates_dir}/${project_id}

bosh -e gcp -d bosh create-env bosh.yml \
  -v "project_id=${project_id}" \
  -v "zone=${zone}" \
  -v "service_account_email=${service_account_email}" \
  -v "network=${network}" \
  -v "subnetwork=${subnetwork}" \
  -v "admin_username=${admin_username}" \
  -v "ssh_key_path=${ssh_key_path}" \
  --vars-store="${privates_dir}/${project_id}/bosh-deployment-vars.yml"

gsutil cp ${privates_dir}/${project_id}/bosh-deployment-vars.yml gs://${project_id}-terraform-config
gsutil cp bosh-state.json gs://${project_id}-terraform-config

mkdir -p $privates_dir/$project_id/certs
erb $gcp_dir/rootCA.pem.erb > $privates_dir/$project_id/certs/rootCA.pem
erb $gcp_dir/admin_password.txt.erb > $privates_dir/$project_id/admin_password.txt

echo "Targeting bosh director. Use the following credentials when prompted"
echo "username: $admin_username"
echo "password: $(cat $privates_dir/$project_id/admin_password.txt)"
bosh -e https://10.0.0.6 --ca-cert privates/twhitney-bosh/certs/rootCA.pem alias-env gcp
bosh -e gcp login

