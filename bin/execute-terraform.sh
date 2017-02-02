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

run_terraform() {
  terraform $1 \
    -var service_account_email=${service_account_email} \
    -var projectid=${project_id} \
    -var region=${region} \
    -var zone=${zone} \
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

export GOOGLE_CREDENTIALS=$(cat ${privates_dir}/terraform.key.json)
[ ! `gsutil ls gs://twhitney-terraform-bosh` ] && gsutil mb gs://twhitney-terraform-bosh
terraform remote config \
  -backend=gcs \
  -backend-config="bucket=twhitney-terraform-bosh" \
  -backend-config="path=terraform.tfstate" \
  -backend-config="project=${project-id}"

echo "Which plan would you like to work with?"
select plan in "Bosh" "Bosh w/ Concourse"; do
  case $plan in
    "Bosh") export plan_dir=$terraform_dir/bosh; break;;
    "Bosh w/ Concourse") 
      cp $terraform_dir/bosh/bosh.tf $terraform_dir/concourse/bosh.tf
      export plan_dir=$terraform_dir/concourse
      break;;
  esac
done

echo "What would you like to do with this plan?"
select action in "Apply" "Destroy"; do
  case $action in
    Apply)
      preview_terraform_plan $plan_dir
      echo "Should we apply this terraform plan?"
      select yn in "Yes" "No"; do
        case $yn in
          Yes) apply_terraform_plan $plan_dir; break;;
          No) exit 0;;
        esac
      done
      break;;
    Destroy) destroy_terraform_plan $plan_dir; break;;
  esac
done

exit 0
