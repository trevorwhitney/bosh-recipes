// Easier mainteance for updating GCE image string
variable "latest_ubuntu" {
    type = "string"
    default = "ubuntu-1404-trusty-v20161109"
}

variable "projectid" {
    type = "string"
}

variable "region" {
    type = "string"
    default = "us-west1"
}

variable "zone" {
    type = "string"
    default = "us-west1-a"
}

variable "prefix" {
    type = "string"
    default = ""
}

variable "service_account_email" {
    type = "string"
    default = ""
}
