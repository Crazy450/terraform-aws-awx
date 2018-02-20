//  This security group allows intra-node communication on all ports with all
//  protocols.
resource "aws_security_group" "awx-vpc" {
  name        = "awx-vpc"
  description = "Default security group that allows all instances in the VPC to talk to each other over any port and protocol."
  vpc_id      = "${aws_vpc.awx.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags {
    Name    = "awx Internal VPC"
    Project = "awx"
  }
}

//  This security group allows public ingress to the instances for HTTP, HTTPS and SSH
//  and common HTTP/S proxy ports.
resource "aws_security_group" "awx-public-ingress" {
  name        = "awx-public-ingress"
  description = "Security group that allows public ingress to instances, HTTP, HTTPS and more."
  vpc_id      = "${aws_vpc.awx.id}"

  //  HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  //  SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name    = "awx Public Access"
    Project = "awx"
  }
}

//  This security group allows public egress from the instances for HTTP and
//  HTTPS, which is needed for yum updates, git access etc etc.
resource "aws_security_group" "awx-public-egress" {
  name        = "awx-public-egress"
  description = "Security group that allows egress to the internet for instances over HTTP and HTTPS."
  vpc_id      = "${aws_vpc.awx.id}"

  //  HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "awx Public Access"
    Project = "awx"
  }
}


// Security Group which allows HTTP and HTTPS traffic from the Load balancers
resource "aws_security_group" "awx-lb-ingress" {
  name        = "awx-lb-ingress"
  description = "Security group that allows public ingress over LB."
  vpc_id      = "${aws_vpc.awx.id}"

  //  HTTP Infra Ingress
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 //  HTTPS Egress
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
   security_groups  = ["${aws_security_group.awx-vpc.id}"]
 }
 //  HTTP Egress
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
   security_groups  = ["${aws_security_group.awx-vpc.id}"]
 }

  tags {
    Name    = "awx LB Ingress"
    Project = "awx"
  }
}