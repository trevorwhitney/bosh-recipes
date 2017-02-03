#!/bin/bash

set -ex

if [ $# -ne 1 ]; then 
  echo "Invalid usage: $0 admin_username"
  exit 1
fi

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

$bin_dir/generate-bosh-manifest.sh $1
bosh-init deploy bosh.yml
gsutil cp ${privates_dir}/${project_id}/bosh-credentials.yml gs://${project_id}-terraform-config
gsutil cp bosh-state.yml gs://${project_id}-terraform-config
