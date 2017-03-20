
resource "aws_route53_zone" "internal" {
#  name = "${lower(var.nameprefix)}-${lower(var.costcenter)}.${lower(data.aws_caller_identity.current.account_id)}.local."
  count = "${var.intdns ? 1 : 0}"
  name = "${data.null_data_source.my.inputs["intdnszone"]}"
  vpc_id = "${aws_vpc.vpc.id}"
  comment = "Internal zone for Private Hosted DNS"

  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}-internal"
  }
}

output "internal_dns_zonename" { value = "${aws_route53_zone.internal.name}" }
output "internal_dns_zoneid" { value = "${aws_route53_zone.internal.zone_id}" }
