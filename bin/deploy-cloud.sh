#/bin/bash

set -ex

if [ $# -ne 1 ]; then 
  echo "Invalid usage: $0 admin_username"
  exit 1
fi

if [ -z "$gcs_access_key" ]; then
  echo "gcs_access_key not set, aborting"
  exit 1
fi

if [ -z "$gcs_secret_access_key" ]; then
  echo "gcs_secret_access_key not set, aborting"
  exit 1
fi

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

$lib_dir/deploy-bosh-director.sh $1
$lib_dir/deploy-concourse.sh
$lib_dir/deploy-cf.sh
