#!/bin/bash

export service_account=bosh-user
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com

if [ ! `gcloud iam service-accounts list | grep ${service_account}`   ]; then
  gcloud iam service-accounts create ${service_account}
  gcloud projects add-iam-policy-binding ${project_id} \
      --member serviceAccount:${service_account_email} \
      --role roles/compute.instanceAdmin
  gcloud projects add-iam-policy-binding ${project_id} \
      --member serviceAccount:${service_account_email} \
      --role roles/compute.storageAdmin
  gcloud projects add-iam-policy-binding ${project_id} \
      --member serviceAccount:${service_account_email} \
      --role roles/storage.admin
  gcloud projects add-iam-policy-binding ${project_id} \
      --member serviceAccount:${service_account_email} \
      --role  roles/compute.networkAdmin
  gcloud projects add-iam-policy-binding ${project_id} \
      --member serviceAccount:${service_account_email} \
      --role roles/iam.serviceAccountActor
fi

if [ ! -e ~/.ssh/bosh ]; then
  ssh-keygen -t rsa -f ~/.ssh/bosh -C bosh
  gcloud compute project-info add-metadata --metadata-from-file \
    sshKeys=<( gcloud compute project-info describe --format=json | jq -r '.commonInstanceMetadata.items[] | select(.key == "sshKeys") | .value' & echo "bosh:$(cat ~/.ssh/bosh.pub)"  )
fi
