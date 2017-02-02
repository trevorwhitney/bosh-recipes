#!/bin/bash

set -ex

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/../../bin/setup_environment.sh

export external_ip=`gcloud compute addresses describe concourse | grep ^address: | cut -f2 -d' '`
export director_uuid=`bosh status --uuid 2>/dev/null`
export common_password=`ruby -ryaml -e "puts YAML.load_file('privates/concourse-credentials.yml')['credentials']['common_password']"`
export atc_password=`ruby -ryaml -e "puts YAML.load_file('privates/concourse-credentials.yml')['credentials']['atc_password']"`

bosh deployment concourse.yml
bosh -n deploy
