//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the internal DNS.
resource "aws_route53_zone" "internal" {
  name = "awx.local"
  comment = "awx Cluster Internal DNS"
  vpc_id = "${aws_vpc.awx.id}"
  tags {
    Name    = "awx Internal DNS"
    Project = "awx"
  }
}

//  DNS for server name resolution.
resource "aws_route53_record" "awx1-a-record" {
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "awx1.awx.local"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.awx1.private_ip}"
    ]
}

//  DNS for Load Balancers
resource "aws_route53_record" "lb-console-a-record" {
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "awx-console.awx.local"
    type = "A"

    alias {
      name = "${aws_lb.awx-console-ingress-lb.dns_name}"
      zone_id = "${aws_lb.awx-console-ingress-lb.zone_id}"
      evaluate_target_health = true
  }
}