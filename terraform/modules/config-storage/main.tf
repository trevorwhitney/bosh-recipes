resource "google_storage_bucket" "terraform-config" {
  name     = "${var.projectid}-terraform-config"
  location = "US"
  force_destroy = true
}

