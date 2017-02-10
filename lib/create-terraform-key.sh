#!/bin/bash

set -ex

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh

export service_account=terraform
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com

gcloud config set compute/zone ${zone}
gcloud config set compute/region ${region}

if [ ! `gcloud iam service-accounts list | grep ${service_account}`  ]; then
  gcloud iam service-accounts create ${service_account}
  gcloud projects add-iam-policy-binding ${project_id} \
      --member serviceAccount:${service_account_email} \
      --role roles/owner
fi

[ ! -e $privates_dir/$project_id/terraform.key.json ] && \
  gcloud iam service-accounts keys create \
    $privates_dir/$project_id/terraform.key.json \
    --iam-account ${service_account_email}
