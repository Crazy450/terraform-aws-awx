// Setup for the Load Balancers
resource "aws_lb" "awx-console-ingress-lb" {
  name            = "awx-console-ingress-lb"
  enable_deletion_protection = "false"
  internal        = "false"
  ip_address_type = "ipv4"
  load_balancer_type = "network"
  subnets = ["${aws_subnet.public-subnet.id}"]
}

// Setup the Target Groups for the Load Balancers
resource "aws_lb_target_group" "awx-console-ingress-80-tg" {
  name     = "awx-console-ingress-80-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${aws_vpc.awx.id}"
  target_type = "instance"

  health_check {
     healthy_threshold = "3"
     interval = "30"
     port = "traffic-port"
     protocol = "TCP"
     unhealthy_threshold = "3"

  }
}

// Setup the Listener for the Load Balancers
resource "aws_lb_listener" "awx-console-ingress-80-lb-lst" {
  load_balancer_arn = "${aws_lb.awx-console-ingress-lb.arn}"
  port =  "80"
  protocol =  "TCP"

    default_action {
    target_group_arn = "${aws_lb_target_group.awx-console-ingress-80-tg.arn}"
    type             = "forward"
  }
}
// Setup for the target endpoint servers.  Replicate this section if more then one host
resource "aws_lb_target_group_attachment" "awx-console-ingress-80-lb-tga1" {
  target_group_arn = "${aws_lb_target_group.awx-console-ingress-80-tg.arn}"
  target_id        = "${aws_instance.awx1.id}"
  port             = 80
}