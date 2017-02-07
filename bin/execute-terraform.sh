#!/bin/sh

set -ex

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

if [ ! -e  $privates_dir/$project_id/terraform.key.json ]; then
  echo "Please create a key for terraform at ${privates_dir}/${project_id}/terraform.key.json by running \
    bin/create_terraform_key.sh"
  exit 1
fi

command -v terraform >/dev/null 2>&1 || { echo "Please install terraform" >&2; exit 1; }
command -v gsutil >/dev/null 2>&1 || { echo "Please install gsutil" >&2; exit 1; }

set +e
[ ! `gsutil ls gs://${project_id}-terraform-config` ] && terraform remote config -disable
set -e

run_terraform() {
  terraform get $2
  terraform $1 \
    -var service_account_email=${service_account_email} \
    -var projectid=${project_id} \
    $2
}

preview_terraform_plan() {
  run_terraform plan $1
}

apply_terraform_plan() {
  run_terraform apply $1
}

destroy_terraform_plan() {
  run_terraform destroy $1
}

setup_terraform_remote_config() {
  terraform remote config \
    -backend=gcs \
    -backend-config="bucket=${project_id}-terraform-config" \
    -backend-config="path=terraform.tfstate" \
    -backend-config="project=${project_id}"

  terraform remote push

  gsutil cp ${privates_dir}/${project_id}/terraform.key.json gs://${project_id}-terraform-config
}

export GOOGLE_CREDENTIALS=$(cat ${privates_dir}/${project_id}/terraform.key.json)
export GOOGLE_APPLICATION_CREDENTIALS=${privates_dir}/${project_id}/terraform.key.json
echo "Which plan would you like to work with?"
select plan in "Bosh" "Bosh w/ Concourse" "Bosh, Concourse, & CF"; do
  case $plan in
    "Bosh") export plan_dir=$terraform_dir/bosh; break;;
    "Bosh w/ Concourse") export plan_dir=$terraform_dir/concourse; break;;
    "Bosh, Concourse, & CF") export plan_dir=$terraform_dir/cf; break;;
  esac
done

echo "What would you like to do with this plan?"
select action in "Preview" "Apply" "Destroy"; do
  case $action in
    Preview) preview_terraform_plan $plan_dir; break;;
    Apply) 
      apply_terraform_plan $plan_dir
      setup_terraform_remote_config
      break;;
    Destroy) destroy_terraform_plan $plan_dir; break;;
  esac
done

exit 0
