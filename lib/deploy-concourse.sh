#!/bin/bash

set -ex

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

command=deploy
$interpolate && command=interpolate

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh

gcloud config set compute/zone ${zone}
gcloud config set compute/region ${region}

source $lib_dir/setup-cf-env.sh

bosh -e gcp -n -d concourse $command \
  --vars-store=$privates_dir/$project_id/concourse-deployment-vars.yml \
  -v external_url="http://$concourse_ip" \
  -v github_client_id="$github_client_id" \
  -v github_client_secret="$github_client_secret" \
  $gcp_dir/concourse.yml

gsutil cp ${privates_dir}/${project_id}/concourse-deployment-vars.yml gs://${project_id}-terraform-config
