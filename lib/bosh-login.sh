#!/bin/bash

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh

parse_password_ruby_cmd="puts YAML.load_file('$privates_dir/$project_id/bosh-deployment-vars.yml')['admin_password']"
password=$(ruby -ryaml -e "${parse_password_ruby_cmd}")

echo "Password: ${password}"

cat > $HOME/.bosh/config <<EOF
  environments:
  - url: https://10.0.0.6
    alias: gcp
    username: nimda
    password: $password
EOF

mkdir -p $privates_dir/$project_id/certs
erb $templates_dir/rootCA.pem.erb > $privates_dir/$project_id/certs/rootCA.pem

bosh -e https://10.0.0.6 --ca-cert privates/twhitney-bosh/certs/rootCA.pem alias-env gcp
bosh -e gcp login
