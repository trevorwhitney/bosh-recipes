#!/bin/bash

set -ex

if [ ! `which gcloud` ]; then
  ./install_google_cloud_sdk.sh --disable-prompts --install-dir=/usr/local/opt
  ln -s /usr/local/opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
  exec -l $SHELL
  gcloud init --skip-diagnostics --console-only
fi

exit 0
