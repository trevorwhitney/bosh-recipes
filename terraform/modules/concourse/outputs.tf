output "network" {
  value = "${google_compute_subnetwork.concourse-subnet-1.name}"
}

output "ip" {
  value = "${google_compute_address.concourse.address}"
}
