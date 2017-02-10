provider "google" {
  credentials = ""
  project = "${var.projectid}"
  region = "us-central1"
}

module "config-storage" {
  source = "../modules/config-storage"

  projectid = "${var.projectid}"
}

module "bosh" {
  source = "../modules/bosh"

  service_account_email = "${var.service_account_email}"
  region = "us-central1"
  zone = "us-central1-b"
}

module "concourse" {
  source = "../modules/concourse"

  region = "us-central1"
  host_network_link = "${module.bosh.network_self_link}"
  host_network_name = "${module.bosh.network_name}"
}

module "cf" {
  source = "../modules/cf"

  projectid = "${var.projectid}"
  region = "us-west1"
  zone = "us-west1-a"
  network = "${module.bosh.network_name}"
}
