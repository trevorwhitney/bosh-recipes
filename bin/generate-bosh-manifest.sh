#!/bin/bash

set -ex

if [ $# -ne 1 ]; then 
  echo "Invalid usage: $0 admin_username"
  exit 1
fi

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

export admin_username=$1
export service_account=bosh-user
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com
mkdir -p ${privates_dir}/${project_id}
erb bosh-credentials.yml.erb > ${privates_dir}/${project_id}/bosh-credentials.yml
erb bosh.yml.erb > bosh.yml
