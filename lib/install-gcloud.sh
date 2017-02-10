#!/bin/bash

set -ex

lib_dir="$(cd $(dirname "$0") && pwd)"
source $lib_dir/setup-environment.sh

if [ ! `which gcloud` ]; then
  $bin_dir/install-google-cloud-sdk.sh --disable-prompts --install-dir=/usr/local/opt
  ln -s /usr/local/opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
  ln -s /usr/local/opt/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil
  source ~/.bash_profile
  gcloud init --skip-diagnostics --console-only
fi

if [ ! `which terraform` ]; then
  brew install terraform
fi

exit 0
