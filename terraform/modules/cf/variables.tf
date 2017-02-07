variable "projectid" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "us-central1"
}

variable "zone" {
  type = "string"
  default = "us-central1-b"
}

variable "region_compilation" {
  type = "string"
  default = "us-central1"
}

variable "zone_compilation" {
  type = "string"
  default = "us-central1-b"
}

variable "network" {
  type = "string"
}

variable "prefix" {
  type = "string"
  default = ""
}