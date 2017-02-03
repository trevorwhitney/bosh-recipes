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

$bin_dir/generate-bosh-manifest.sh $1
bosh-init deploy bosh.yml
gsutil cp ${privates_dir}/${project_id}/bosh-credentials.yml gs://${project_id}-terraform-config
gsutil cp bosh-state.yml gs://${project_id}-terraform-config
