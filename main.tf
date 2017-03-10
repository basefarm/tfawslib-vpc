#variable "" { default= type="string" }
variable "region" { type="string" }
variable "costcenter" { type="string" }
variable "nameprefix" { type="string" }
variable "netaddr" { default="10.0.0.0" type="string" }
variable "netsize" { default="24" type="string" }
variable "azcount" { default="3" type="string" }

data "null_data_source" "my" {
  inputs = {
    subsize = "${max( 22, min(var.netsize+4, 28))}"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "${var.netaddr}/${var.netsize}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${nameprefix}"
  }
}

output "subsize" { value = "${data.null_data_source.my.inputs["subsize"] }" }
output "vpcid" { value = "${aws_vpc.main.id}" }
