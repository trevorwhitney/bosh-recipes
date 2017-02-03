#!/bin/bash

set -ex

if [ $# -ne 1 ]; then 
  echo "Invalid usage: $0 admin_username"
  exit 1
fi

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

export service_account=bosh-user
export project_id=$(gcloud config list 2>/dev/null | grep project | sed -e 's/project = //g')
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com
[ ! `gcloud iam service-accounts list | grep ${service_account}`  ] && \
  gcloud iam service-accounts create ${service_account}

export admin_username=$1
mkdir -p ${privates_dir}/${project_id}
erb bosh-credentials.yml.erb > ${privates_dir}/${project_id}/bosh-credentials.yml
erb bosh.yml.erb > bosh.yml
