#!/bin/bash

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh

export service_account=cf-component
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com

if [ ! `gcloud iam service-accounts list | grep ${service_account}`   ]; then
  gcloud iam service-accounts create ${service_account}
  gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:${service_account_email} \
    --role "roles/editor" \
    --role "roles/logging.logWriter" \
    --role "roles/logging.configWriter"
fi

