#!/bin/bash

set -ex

if [ -z "$gcs_access_key" ]; then
  echo "gcs_access_key not set, aborting"
  exit 1
fi

if [ -z "$gcs_secret_access_key" ]; then
  echo "gcs_secret_access_key not set, aborting"
  exit 1
fi

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh

export region="us-west1-a"
export zone="us-west1-a"

gcloud config set compute/region $region
gcloud config set compute/zone $zone

source $lib_dir/setup-cf-env.sh

bosh -e gcp -n -d cf deploy \
  --vars-store=$privates_dir/$project_id/cf-deployment-vars.yml \
  -v system_domain="$ip.xip.io" \
  -v gcs_access_key=$gcs_access_key \
  -v gcs_secret_access_key=$gcs_secret_access_key \
  -v gcs_buildpack_bucket=$gcs_buildpack_bucket \
  -v gcs_droplet_bucket=$gcs_droplet_bucket \
  -v gcs_package_bucket=$gcs_package_bucket \
  -v gcs_resource_bucket=$gcs_resource_bucket \
  $gcp_dir/cf-deployment-minimal.yml

gsutil cp privates/twhitney-bosh/cf-deployment-vars.yml gs://twhitney-bosh-terraform-config
