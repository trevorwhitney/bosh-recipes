# BOSH on Google Cloud Platform

## Installation

Follow the instructions [here](https://github.com/cloudfoundry-incubator/bosh-google-cpi-release/tree/master/docs/bosh),
with additional instructions [here](https://medium.com/google-cloud/playing-with-concourseci-via-a-google-cloud-platform-free-trial-65acfbdd02d2)

1. [Sign up](https://cloud.google.com/compute/docs/signup) for Google Cloud Platform
1. Create a [new project](https://console.cloud.google.com/iam-admin/projects)
1. Enable the [GCE API](https://console.developers.google.com/apis/api/compute_component/overview) for your project
1. Enable the [IAM API](https://console.cloud.google.com/apis/api/iam.googleapis.com/overview) for your project
1. Enable the [Cloud Resource Manager API](https://console.cloud.google.com/apis/api/cloudresourcemanager.googleapis.com/overview)
1. `bin/install_gcloud.sh`
1. `gcloud config set project [PROJECT_ID]`
1. `bin/create_terraform_key.sh`
1. `bin/execute_terraform.sh`
1. `bin/setup-bosh-service-account.sh`
1. `gcloud compute ssh bosh-bastion`
1. clone this repository to `~/workspace/bosh-recipes`
1. `cd ~/workspace/bosh-recipes`
1. `bin/deploy-bosh-director.sh [ADMIN_USERNAME]`
1. `bosh target 10.0.0.6`
1. `bosh upload stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3312.17`
1. `bosh upload release https://bosh.io/d/github.com/concourse/concourse?v=2.6.0`
1. `bosh upload release https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.1.1`
1. `export zone2=us-central1-c`
1. `bosh update cloud-config concourse-cloud-config.yml`
1. `erb concourse-credentials.yml.erb > privates/concourse-credentials.yml`
1. `bin/deploy-concourse.sh`

