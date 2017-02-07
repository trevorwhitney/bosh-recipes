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

gsutil cp gs://twhitney-bosh-terraform-config/terraform.tfstate .

export vip=$(terraform output -module=cf ip)
export zone=$(terraform output -module=cf zone)
export zone_compilation=$(terraform output -module=cf zone_compilation)
export region=$(terraform output -module=cf region)
export region_compilation=$(terraform output -module=cf region_compilation)
export private_subnet=$(terraform output -module=cf private_subnet)
export compilation_subnet=$(terraform output -module=cf compilation_subnet)
export network=$(terraform output -module=cf network)

export gcs_buildpack_bucket=$(terraform output -module=cf cf_buildpack_bucket)
export gcs_droplet_bucket=$(terraform output -module=cf cf_droplet_bucket)
export gcs_package_bucket=$(terraform output -module=cf cf_package_bucket)
export gcs_resource_bucket=$(terraform output -module=cf cf_resource_bucket)

export concourse_region="us-central1"

export director=$(bosh status --uuid)

bosh upload release https://bosh.io/d/github.com/cloudfoundry/cf-mysql-release?v=23
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/garden-linux-release?v=0.340.0
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/etcd-release?v=36
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/diego-release?v=0.1454.0
bosh upload release https://bosh.io/d/github.com/cloudfoundry/cf-release?v=231

bosh update cloud-config $cf_dir/cloud-config.yml
bosh deployment $cf_dir/cf-minimal.yml
bosh -n deploy
