// Subnet for the public Cloud Foundry components
resource "google_compute_subnetwork" "cf-compilation-subnet-1" {
  name          = "${var.prefix}cf-compilation-${var.region_compilation}"
  region        = "${var.region_compilation}"
  ip_cidr_range = "10.200.0.0/16"
  network       = "https://www.googleapis.com/compute/v1/projects/${var.projectid}/global/networks/${var.network}"

}

// Subnet for the private Cloud Foundry components
resource "google_compute_subnetwork" "cf-private-subnet-1" {
  name          = "${var.prefix}cf-private-${var.region}"
  ip_cidr_range = "192.168.0.0/16"
  network       = "https://www.googleapis.com/compute/v1/projects/${var.projectid}/global/networks/${var.network}"
}

// Allow access to CloudFoundry router
resource "google_compute_firewall" "cf-public" {
  name    = "${var.prefix}cf-public"
  network       = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "2222", "4443"]
  }

  target_tags = ["cf-public"]
}

// Static IP address for forwarding rule
resource "google_compute_address" "cf" {
  name = "${var.prefix}cf"
  region = "${var.region}"
}

// Health check
resource "google_compute_http_health_check" "cf-public" {
  name                = "${var.prefix}cf-public"
  host                = "api.${google_compute_address.cf.address}.xip.io"
  request_path        = "/info"
  check_interval_sec  = 30
  timeout_sec         = 5
  healthy_threshold   = 10
  unhealthy_threshold = 2
  port = 80
}

// Load balancing target pool
resource "google_compute_target_pool" "cf-public" {
  name = "${var.prefix}cf-public"
  region = "${var.region}"

  health_checks = [
    "${google_compute_http_health_check.cf-public.name}"
  ]
}

// HTTP forwarding rule
resource "google_compute_forwarding_rule" "cf-http" {
  name        = "${var.prefix}cf-http"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "80"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
  region = "${var.region}"
}

// HTTP forwarding rule
resource "google_compute_forwarding_rule" "cf-https" {
  name        = "${var.prefix}cf-https"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
  region = "${var.region}"
}

// SSH forwarding rule
resource "google_compute_forwarding_rule" "cf-ssh" {
  name        = "${var.prefix}cf-ssh"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "2222"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
  region = "${var.region}"
}

// WSS forwarding rule
resource "google_compute_forwarding_rule" "cf-wss" {
  name        = "${var.prefix}cf-wss"
  target      = "${google_compute_target_pool.cf-public.self_link}"
  port_range  = "4443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
  region = "${var.region}"
}

