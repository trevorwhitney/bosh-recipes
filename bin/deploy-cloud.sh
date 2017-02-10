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

try_twice() {
  echo "Called with: ${@}"
  n=0
  until [ $n -ge 2 ]
  do
    ${@} && break
    n=$[$n+1]
    echo "Command ${@} failed, trying again..."
    sleep 5
  done

  echo "Expected ${@} to succeed, but it failed after 2 trys."
  exit 1
}

try_twice $lib_dir/deploy-bosh-director.sh $1
$lib_dir/update-cloud-config.sh
try_twice $lib_dir/deploy-cf.sh
$lib_dir/cf-login.sh
try_twice $lib_dir/deploy-concourse.sh
