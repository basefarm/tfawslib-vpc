resource "aws_security_group" "unrestricted_egress" {
  name = "unrestricted_egress"
  description = "Default allow egress"
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}_unrestricted_egress"
  }
}
resource "aws_security_group_rule" "unrestricted_egress_01" {
  security_group_id = "${aws_security_group.unrestricted_egress.id}"
  type = "egress"
  protocol = "tcp"
  from_port = 0
  to_port = 65535
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "allow_inbound_http_https" {
  name        = "allow_inbound_http_https"
  description = "Allow all inbound HTTP and HTTPS traffic"
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}_allow_inbound_http_https"
  }
}
resource "aws_security_group_rule" "allow_inbound_http_https_01" {
  security_group_id = "${aws_security_group.allow_inbound_http_https.id}"
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "allow_inbound_http_https_02" {
  security_group_id = "${aws_security_group.allow_inbound_http_https.id}"
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
}

