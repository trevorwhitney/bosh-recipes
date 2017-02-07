variable "projectid" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "us-west1"
}

variable "zone" {
  type = "string"
  default = "us-west1-a "
}

variable "region_compilation" {
  type = "string"
  default = "us-east1"
}

variable "zone_compilation" {
  type = "string"
  default = "us-east1-d"
}

variable "network" {
  type = "string"
}

variable "prefix" {
  type = "string"
  default = ""
}