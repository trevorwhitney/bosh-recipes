module "config-storage" {
  source = "../modules/config-storage"

  projectid = "${var.projectid}"
  region = "${var.region}"
} 

module "bosh" {
  source = "../modules/bosh"

  service_account_email = "${var.service_account_email}"
  projectid = "${var.projectid}"
  region = "${var.region}"
  zone = "${var.zone}"
}

module "concourse" {
  source = "../modules/concourse"

  projectid = "${var.projectid}"
  region = "${var.region}"
  host_network_link = "${module.bosh.network_self_link}"
  host_network_name = "${module.bosh.network_name}"
}
