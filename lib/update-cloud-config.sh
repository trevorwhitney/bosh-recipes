#!/bin/bash

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh
source $lib_dir/setup-cf-env.sh

bosh -e gcp -n update-cloud-config $gcp_dir/cloud-config.yml \
  -v "zone_1=us-west1-a" \
  -v "zone_2=us-central1-b" \
  -v "cf_service_account=$service_account_email" \
  -v "google_zone_compilation=$zone_compilation" \
  -v "google_region_compilation=$region_compilation" \
  -v "concourse_region=us-central1" \
  -v "network=$network" \
  -v "private_subnetwork=$private_subnet" \
  -v "compilation_subnetwork=$compilation_subnet"
