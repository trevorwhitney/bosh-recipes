#!/bin/bash

set -ex

if [ $# -ne 1 ]; then 
  echo "Invalid usage: $0 admin_username"
  exit 1
fi

export service_account=bosh-user
export project_id=$(gcloud config list 2>/dev/null | grep project | sed -e 's/project = //g')
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com
gcloud iam service-accounts create ${service_account}

export admin_username=$1
erb bosh-credentials.yml.erb > bosh-credentials.yml
erb bosh.yml.erb > bosh.yml
