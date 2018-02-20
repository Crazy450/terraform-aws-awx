variable "region" {
description = "The region to deploy the cluster i, e.g: ca-central-1."
}

variable "amisize" {
  description = "The size of the cluster nodes, e.g: t2.medium."
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 192.168.0.0/19"
}

variable "subnetaz" {
  description = "The AZ for the public subnet, e.g: ca-central-1a"
  type = "map"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet, e.g: 192.168.2.0/24"
}

variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: consul-cluster"
}

variable "public_key_path" {
  description = "The local public key path, e.g. ~/.ssh/id_rsa.pub"
}