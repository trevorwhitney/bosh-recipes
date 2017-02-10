#!/bin/bash

set -ex

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh

source $lib_dir/setup-cf-env.sh

ruby_command="puts YAML.load_file('$privates_dir/$project_id/cf-deployment-vars.yml')['uaa_scim_users_admin_password']"
password=$(ruby -ryaml -e "${ruby_command}")

cf api "https://api.${ip}.xip.io" --skip-ssl-validation
cf auth admin $password
cf create-org concourse
cf create-space -o concourse concourse
