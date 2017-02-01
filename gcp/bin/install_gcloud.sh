#!/bin/bash

set -ex

bin_dir="$(cd $(dirname "$0") && pwd)"
source $bin_dir/setup_environment.sh

if [ ! `which gcloud` ]; then
  $bin_dir/install_google_cloud_sdk.sh --disable-prompts --install-dir=/usr/local/opt
  ln -s /usr/local/opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
  ln -s /usr/local/opt/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil
  source ~/.bash_profile
  gcloud init --skip-diagnostics --console-only
fi

exit 0
