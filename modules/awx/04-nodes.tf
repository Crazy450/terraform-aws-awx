//  Create an SSH keypair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

// Preparation Work on Servers script.
data "template_file" "prep-work" {
  template = "${file("${path.module}/files/prep_work.sh")}"

}

//  Creating the Master Servers Section
resource "aws_instance" "awx1" {
  ami                  = "ami-dcad28b8"
  instance_type        = "t2.medium"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.awx-instance-profile.id}"
  user_data            = "${data.template_file.prep-work.rendered}"

  security_groups = [
    "${aws_security_group.awx-vpc.id}",
    "${aws_security_group.awx-public-ingress.id}",
    "${aws_security_group.awx-public-egress.id}",
  ]

  root_block_device {
    volume_size = 50
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 40
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  tags {
    Name    = "awx 1"
    Project = "awx"
  }
}