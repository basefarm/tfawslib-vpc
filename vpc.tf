resource "aws_vpc" "vpc" {
  cidr_block = "${var.netaddr}/${var.netsize}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}"
  }
}

output "vpcid" { value = "${aws_vpc.vpc.id}" }
