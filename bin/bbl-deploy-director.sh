#!/bin/bash

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

bbl up \
  --iaas gcp \
  --gcp-project-id $project_id \
  --gcp-service-account-key $privates_dir/$project_id/terraform.key.json \
  --gcp-region $region \
  --gcp-zone $zone
