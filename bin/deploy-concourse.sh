#!/bin/bash

set -ex

if [ -z "$github_client_id" ]; then
  echo "github_client_id not set, aborting"
  exit 1
fi

if [ -z "$github_client_secret" ]; then
  echo "github_client_secret not set, aborting"
  exit 1
fi

lib_dir="$(cd $(dirname "$0")/../lib && pwd)"
source $lib_dir/setup-environment.sh

export external_ip=`gcloud compute addresses describe concourse | grep ^address: | cut -f2 -d' '`

bosh -e gcp -n -d concourse deploy \
  --vars-store=$privates_dir/$project_id/concourse-deployment-vars.yml \
  -v external_url="$external_ip" \
  -v github_client_id="$github_client_id" \
  -v github_client_secret="$github_client_secret" \
  $gcp_dir/concourse.yml

gsutil cp ${privates_dir}/${project_id}/concourse-deployment-vars.yml gs://${project_id}-terraform-config
