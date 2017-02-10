resource "google_compute_subnetwork" "concourse-subnet-1" {
  name          = "concourse-private-${var.region}-1"
  ip_cidr_range = "10.150.0.0/16"
  network       = "${var.host_network_link}"
}

resource "google_compute_firewall" "concourse-public" {
  name    = "concourse-public"
  network = "${var.host_network_name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443", "4443"]
  }
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["concourse-public"]
}

resource "google_compute_firewall" "concourse-internal" {
  name    = "concourse-internal"
  network = "${var.host_network_name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  target_tags = ["concourse-internal", "bosh-internal"]
  source_tags = ["concourse-internal", "bosh-internal"]
}

resource "google_compute_address" "concourse" {
  name = "concourse"
}

resource "google_compute_target_pool" "concourse-target-pool" {
  name = "concourse-target-pool"
}

resource "google_compute_forwarding_rule" "concourse-http-forwarding-rule" {
  name        = "concourse-http-forwarding-rule"
  target      = "${google_compute_target_pool.concourse-target-pool.self_link}"
  port_range  = "80-80"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.concourse.address}"
}

resource "google_compute_forwarding_rule" "concourse-https-forwarding-rule" {
  name        = "concourse-https-forwarding-rule"
  target      = "${google_compute_target_pool.concourse-target-pool.self_link}"
  port_range  = "443-443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.concourse.address}"
}
