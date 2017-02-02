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
