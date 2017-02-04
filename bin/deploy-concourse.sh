#!/bin/bash

set -ex

if [ -z "$github_client_id" ]; then
  echo "github_client_id not set, aborting"
  exit 1
fi

if [ -z "$github_client_id" ]; then
  echo "github_client_secret not set, aborting"
  exit 1
fi

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

bosh upload stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3312.17
bosh upload release https://bosh.io/d/github.com/concourse/concourse?v=2.6.0
bosh upload release https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.1.1
bosh update cloud-config concourse/cloud-config.yml
erb $concourse_dir/credentials.yml.erb > ${privates_dir}/concourse-credentials.yml

export external_ip=`gcloud compute addresses describe concourse | grep ^address: | cut -f2 -d' '`
export director_uuid=`bosh status --uuid 2>/dev/null`
credentials=`ruby $bin_dir/parse-credentials.rb`

export atc_password=`echo $credentials | jq .atc_password`
export common_password=`echo $credentials | jq .common_password`

bosh update cloud-config $concourse_dir/cloud-config.yml
bosh deployment $concourse_dir/concourse.yml
bosh -n deploy

gsutil cp ${privates_dir}/concourse-credentials.yml gs://${project_id}-terraform-config
