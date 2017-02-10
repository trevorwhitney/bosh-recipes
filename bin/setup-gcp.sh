#!/bin/bash

set -ex

if [ $# -ne 1 ]; then 
  echo "Invalid usage: $0 project_id"
  exit 1
fi

lib_dir="$(cd $(dirname "$0")/../lib && pwd)"

$lib_dir/install-gcloud.sh
gcloud config set project $1

source $lib_dir/setup-environment.sh

$lib_dir/create-terraform-key.sh
$lib_dir/setup-bosh-service-account.sh
$lib_dir/setup-cf-service-account.sh
$lib_dir/execute-terraform.sh
