//  The region we will deploy our cluster into.
variable "region" {
  description = "Region to deploy the cluster into"
    default = "ca-central-1"
}
//  This map defines which AZ to put the 'Public Subnet' in.
variable "subnetaz" {
  type = "map"

  default = {
    ca-central-1 = "ca-central-1a"
    ca-central-1 = "ca-central-1b"
 }
}

variable "profile" {
  description = "Profile configured using aws-cli"
  default = "$ProfileName"
}

// Thill provide a Default key naming
variable "keyname" {
  default = "awx"
}

// Will define de VPC Subnet
variable "vpc_subnet" {
  default = "192.168.0.0/19"
}

// This will define the subnets available within the vpc
variable "dmz_subnet_ids" {
  default = ["192.168.1.0/24", "192168.2.0/24"]
}
variable "public_subnet_ids" {
  default = "192.168.3.0/24"
}

//  The public key to use for SSH access.
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

// Will define the size of the AMI
variable "ami_type" {
  default = "t2.medium"
}

variable "ami_label" {
  default = "ami-dcad28b8"
}