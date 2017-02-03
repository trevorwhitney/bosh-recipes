variable "projectid" {
  type = "string"
}

variable "service_account_email" {
    type = "string"
    default = ""
}

variable "region" {
    type = "string"
    default = "us-central1"
}

variable "zone" {
    type = "string"
    default = "us-central1-b"
}
