#!/bin/bash

set -ex

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

gcloud config set compute/zone ${zone}
gcloud config set compute/region ${region}

if [ ! `gcloud iam service-accounts list | grep ${service_account}`  ]; then
  gcloud iam service-accounts create ${service_account}
  gcloud projects add-iam-policy-binding ${project_id} \
      --member serviceAccount:${service_account_email} \
      --role roles/owner
fi

[ ! -e $privates_dir/terraform.key.json ] && \
  gcloud iam service-accounts keys create \
    $privates_dir/terraform.key.json \
    --iam-account ${service_account_email}
