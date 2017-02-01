#!/bin/sh

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

if [ ! -e  $privates_dir/terraform.key.json ]; then
  echo "Please create a key for terraform at ${privates_dir}/terraform.key.json by running \
    bin/create_terraform_key.sh"
  exit 1
fi

run_terraform() {
  docker run -i -t \
    -e "GOOGLE_CREDENTIALS=${GOOGLE_CREDENTIALS}" \
    -v $gcp_dir:/$(basename $gcp_dir) \
    -w /$(basename $gcp_dir) \
    hashicorp/terraform:light $1 \
      -var service_account_email=${service_account_email} \
      -var projectid=${project_id} \
      -var region=${region} \
      -var zone=${zone}
}

preview_terraform_plan() {
  run_terraform plan
}

apply_terraform_plan() {
  run_terraform apply
}

refresh_terraform() {
  run_terraform refresh
}

export GOOGLE_CREDENTIALS=$(cat ${privates_dir}/terraform.key.json)
refresh_terraform
preview_terraform_plan
echo "Should we apply this terraform plan?"
select yn in "Yes" "No"; do
  case $yn in
    Yes) apply_terraform_plan; break;;
    No) exit 0;;
  esac
done

exit 0
