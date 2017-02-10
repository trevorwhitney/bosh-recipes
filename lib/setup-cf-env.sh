#!/bin/bash

set -ex

gsutil cp gs://twhitney-bosh-terraform-config/terraform.tfstate .

get_terraform_output() {
  [ $# -ne 2 ] && echo "Incorrect usage: $0 module output" && exit 1
  terraform output -module=${1} ${2}
}

export vip=$(get_terraform_output cf ip)
export zone=$(get_terraform_output cf zone)
export zone_compilation=$(get_terraform_output cf zone_compilation)
export region=$(get_terraform_output cf region)
export region_compilation=$(get_terraform_output cf region_compilation)
export private_subnet=$(get_terraform_output cf private_subnet)
export compilation_subnet=$(get_terraform_output cf compilation_subnet)
export network=$(get_terraform_output cf network)
export ip=$(get_terraform_output cf ip)

export service_account=cf-component
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com

export gcs_buildpack_bucket=$(get_terraform_output cf cf_buildpack_bucket)
export gcs_droplet_bucket=$(get_terraform_output cf cf_droplet_bucket)
export gcs_package_bucket=$(get_terraform_output cf cf_package_bucket)
export gcs_resource_bucket=$(get_terraform_output cf cf_resource_bucket)

export concourse_network=$(get_terraform_output concourse network)
export concourse_ip=$(get_terraform_output concourse ip)
