#!/bin/bash

set -ex

export gcp_dir="$(cd $lib_dir/.. && pwd)"
mkdir -p $gcp_dir/privates
export privates_dir="$(cd ${gcp_dir}/privates && pwd)"
export terraform_dir="$(cd ${gcp_dir}/terraform && pwd)"
export concourse_dir="$(cd ${gcp_dir}/concourse && pwd)"
export cf_dir="$(cd ${gcp_dir}/cf && pwd)"
export templates_dir="$(cd ${gcp_dir}/templates && pwd)"

export project_id=$(gcloud config list 2>/dev/null | grep project | sed -e 's/project = //g')
export region=us-central1
export zone=us-central1-b
export zone2=us-central1-c
