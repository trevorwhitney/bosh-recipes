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

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

export region="us-west1-a"
export zone="us-west1-a"

gcloud config set compute/region $region
gcloud config set compute/zone $zone

source $bin_dir/setup-cf-env.sh

bosh -e gcp -d cf upload-stemcell \
  https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3312.17

bosh -e gcp -d cf -n update-cloud-config $cf_dir/cloud-config.yml \
  -v "zone_1=us-west1-a" \
  -v "zone_2=us-west1-b" \
  -v "cf_service_account=$service_account_email" \
  -v "google_zone_compilation=$zone_compilation" \
  -v "google_region_compilation=$region_compilation" \
  -v "concourse_region=us-central1" \
  -v "network=$network" \
  -v "private_subnetwork=$private_subnet" \
  -v "compilation_subnetwork=$compilation_subnet"

bosh -e gcp -n -d cf deploy \
  --vars-store=$privates_dir/$project_id/cf-deployment-vars.yml \
  -v system_domain="$ip.xip.io" \
  -v gcs_access_key=$gcs_access_key \
  -v gcs_secret_access_key=$gcs_secret_access_key \
  -v gcs_buildpack_bucket=$gcs_buildpack_bucket \
  -v gcs_droplet_bucket=$gcs_droplet_bucket \
  -v gcs_package_bucket=$gcs_package_bucket \
  -v gcs_resource_bucket=$gcs_resource_bucket \
  $cf_dir/cf-deployment-minimal.yml

gsutil cp privates/twhitney-bosh/cf-deployment-vars.yml gs://twhitney-bosh-terraform-config
