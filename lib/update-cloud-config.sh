#!/bin/bash

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh
source $lib_dir/setup-cf-env.sh

display_help() {
  echo "Usage: $0 [option...]" >&2
  echo
  echo "   -i           interpolate the cloud config instead of updating it"
  echo "   -h           display this help message"
  echo
  exit 1
}

interpolate=false
while getopts "ih" opt; do
  echo $opt
  case "${opt}" in
    i) interpolate=true ;;
    h) display_help ;;
    *) error "Unexpected option ${opt}" ;;
  esac
done

command=update-cloud-config
$interpolate && command=interpolate

bosh -e gcp -n $command $gcp_dir/cloud-config.yml \
  -v "zone_1=us-west1-a" \
  -v "zone_2=us-central1-b" \
  -v "cf_service_account=$service_account_email" \
  -v "google_zone_compilation=$zone_compilation" \
  -v "google_region_compilation=$region_compilation" \
  -v "concourse_network=$concourse_network" \
  -v "network=$network" \
  -v "private_subnetwork=$private_subnet" \
  -v "compilation_subnetwork=$compilation_subnet"
