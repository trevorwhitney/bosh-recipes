#!/bin/bash

set -ex

gsutil cp gs://twhitney-bosh-terraform-config/terraform.tfstate .

export vip=$(terraform output -module=cf ip)
export zone=$(terraform output -module=cf zone)
export zone_compilation=$(terraform output -module=cf zone_compilation)
export region=$(terraform output -module=cf region)
export region_compilation=$(terraform output -module=cf region_compilation)
export private_subnet=$(terraform output -module=cf private_subnet)
export compilation_subnet=$(terraform output -module=cf compilation_subnet)
export network=$(terraform output -module=cf network)
export ip=$(terraform output -module=cf ip)

export service_account=cf-component
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com

export gcs_buildpack_bucket=$(terraform output -module=cf cf_buildpack_bucket)
export gcs_droplet_bucket=$(terraform output -module=cf cf_droplet_bucket)
export gcs_package_bucket=$(terraform output -module=cf cf_package_bucket)
export gcs_resource_bucket=$(terraform output -module=cf cf_resource_bucket)

export concourse_region="us-central1"
