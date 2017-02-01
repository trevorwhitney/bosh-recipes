#!/bin/bash

export gcp_dir="$(cd $bin_dir/.. && pwd)"
export privates_dir="$(cd ${gcp_dir}/privates && pwd)"
export terraform_dir="$(cd ${gcp_dir}/terraform && pwd)"

export project_id=$(gcloud config list 2>/dev/null | grep project | sed -e 's/project = //g')
export region=us-central1
export zone=us-central1-b
export zone2=us-central1-c
export service_account=terraform
export service_account_email=${service_account}@${project_id}.iam.gserviceaccount.com
