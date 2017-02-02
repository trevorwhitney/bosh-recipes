#!/bin/sh

set -ex

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

if [ ! -e  $privates_dir/terraform.key.json ]; then
  echo "Please create a key for terraform at ${privates_dir}/terraform.key.json by running \
    bin/create_terraform_key.sh"
  exit 1
fi

command -v terraform >/dev/null 2>&1 || { echo "Please install terraform" >&2; exit 1; }
command -v gsutil >/dev/null 2>&1 || { echo "Please install gsutil" >&2; exit 1; }


export GOOGLE_CREDENTIALS=$(cat ${privates_dir}/terraform.key.json)
terraform get terraform/concourse
terraform plan \
  -var service_account_email=${service_account_email} \
  -var projectid=${project_id} \
  -var region=${region} \
  -var zone=${zone} \
  terraform/concourse

exit 0
