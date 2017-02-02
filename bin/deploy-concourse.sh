#!/bin/bash

set -ex

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

export external_ip=`gcloud compute addresses describe concourse | grep ^address: | cut -f2 -d' '`
export director_uuid=`bosh status --uuid 2>/dev/null`
credentials=`ruby $bin_dir/parse-credentials.rb`

export atc_password=`echo $credentials | jq .atc_password`
export common_password=`echo $credentials | jq .common_password`

bosh update cloud-config $concourse_dir/concourse-cloud-config.yml
bosh deployment $concourse_dir/concourse.yml
bosh -n deploy
