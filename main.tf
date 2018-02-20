//  Setup the core provider information.
provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

//  Create the awx instance using our module.
module "awx" {
  source          = "./modules/awx"
  region          = "${var.region}"
  amisize         = "${var.ami_type}"
  vpc_cidr        = "${var.vpc_subnet}"
  subnetaz        = "${var.subnetaz}"
  subnet_cidr     = "${var.public_subnet_ids}"
  key_name        = "${var.keyname}"
  public_key_path = "${var.public_key_path}"
}

//  Output some useful variables for quick SSH access etc.