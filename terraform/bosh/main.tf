provider "google" {
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
