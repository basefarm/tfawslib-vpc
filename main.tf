#variable "" { default= type="string" }
variable "region" { type="string" }
variable "costcenter" { type="string" }
variable "nameprefix" { type="string" }
variable "netaddr" { default="10.0.0.0" type="string" }
variable "netsize" { default="24" type="string" }
variable "azcount" { default="3" type="string" }

data "null_data_source" "my" {
  inputs = {
    newbits = "${max(2, max( 22, min(var.netsize+4, 28))-var.netsize})"
    
  }
}

data "aws_availability_zones" "available" {}


output "newbits" { value = "${data.null_data_source.my.inputs["newbits"] }" }
