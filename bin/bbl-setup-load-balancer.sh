#!/bin/bash

set -ex

export BOSH_CLIENT=`bbl director-username`
export BOSH_CLIENT_SECRET=`bbl director-password`
export BOSH_CA_CERT=`bbl director-ca-cert`
export BOSH_ENVIRONMENT=`bbl director-address`

bosh -e $BOSH_ENVIRONMENT alias-env gcp-bbl
bosh -e gcp-bbl login

bbl create-lbs --type cf
