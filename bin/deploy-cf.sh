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

bosh upload release https://bosh.io/d/github.com/cloudfoundry/cf-mysql-release?v=23
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/garden-linux-release?v=0.340.0
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/etcd-release?v=36
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/diego-release?v=0.1454.0
bosh upload release https://bosh.io/d/github.com/cloudfoundry/cf-release?v=231

bosh update cloud-config $cf_dir/cloud-config.yml
bosh deployment $cf_dir/cf-minimal.yml
bosh -n deploy
