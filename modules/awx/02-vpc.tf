//  Define the VPC.
resource "aws_vpc" "awx" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags {
    Name    = "awx VPC"
    Project = "awx"
  }
}

//  Create an Internet Gateway for the VPC.
resource "aws_internet_gateway" "awx" {
  vpc_id = "${aws_vpc.awx.id}"

  tags {
    Name    = "awx IGW"
    Project = "awx"
  }
}

//  Create a public subnet.
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.awx.id}"
  cidr_block              = "${var.subnet_cidr}"
  availability_zone       = "${lookup(var.subnetaz, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.awx"]

  tags {
    Name    = "awx Public Subnet"
    Project = "awx"
  }
}

//  Create a route table allowing all addresses access to the IGW.
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.awx.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.awx.id}"
  }

  tags {
    Name    = "awx Public Route Table"
    Project = "awx"
  }
}

//  Now associate the route table with the public subnet - giving
//  all public subnet instances access to the internet.
resource "aws_route_table_association" "public-subnet" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}
