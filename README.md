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
1. `bin/setup-cf-service-account.sh`
1. `gcloud compute ssh bosh-bastion`
1. clone this repository to `~/workspace/bosh-recipes`
1. `cd ~/workspace/bosh-recipes`
1. `bin/deploy-bosh-director.sh [ADMIN_USERNAME]`
1. `bosh target 10.0.0.6`
1. `github_client_id=[GITHUB_CLIENT_ID] github_client_secret=[GITHUB_CLIENT_SECRET] bin/deploy-concourse.sh`
1. You will need to create an [interoperability key](https://cloud.google.com/storage/docs/migrating#keys) to use google cloud storage as your blobstore.
1. `gcs_access_key=[GCS_ACCESS_KEY] gcs_secret_access_key=[GCS_SECRET_ACCESS_KEY] bin/deploy-cf.sh`

