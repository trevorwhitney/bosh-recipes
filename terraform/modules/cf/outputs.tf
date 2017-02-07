output "ip" {
  value = "${google_compute_address.cf.address}"
}

output "network" {
  value = "${var.network}"
}
output "private_subnet" {
  value = "${google_compute_subnetwork.cf-private-subnet-1.name}"
}

output "compilation_subnet" {
  value = "${google_compute_subnetwork.cf-compilation-subnet-1.name}"
}

output "zone" {
  value = "${var.zone}"
}

output "zone_compilation" {
  value = "${var.zone_compilation}"
}

output "region" {
  value = "${var.region}"
}

output "region_compilation" {
  value = "${var.region_compilation}"
}

output "cf_buildpack_bucket" {
  value = "${google_storage_bucket.buildpacks.name}"
}

output "cf_droplet_bucket" {
  value = "${google_storage_bucket.droplets.name}"
}

output "cf_package_bucket" {
  value = "${google_storage_bucket.packages.name}"
}

output "cf_resource_bucket" {
  value = "${google_storage_bucket.resources.name}"
}
