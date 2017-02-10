output "network" {
  value = "${google_compute_subnetwork.concourse-public-subnet-1.name}"
}
