provider "google" {
  credentials = ""
  project = "${var.projectid}"
  region = "${var.region}"
}

module "config-storage" {
  source = "../modules/config-storage"

  projectid = "${var.projectid}"
}

module "bosh" {
  source = "../modules/bosh"

  service_account_email = "${var.service_account_email}"
  region = "${var.region}"
  zone = "${var.zone}"
}

module "concourse" {
  source = "../modules/concourse"

  region = "${var.region}"
  host_network_link = "${module.bosh.network_self_link}"
  host_network_name = "${module.bosh.network_name}"
}

module "cf" {
  source = "../modules/cf"

  projectid = "${var.projectid}"
  region = "${var.region}"
  network = "${module.bosh.network_name}"
}
