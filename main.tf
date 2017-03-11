#variable "" { default= type="string" }
variable "region" { type="string" }
variable "costcenter" { type="string" }
variable "nameprefix" { type="string" }
variable "netaddr" { default="10.0.0.0" type="string" }
variable "netsize" { default="24" type="string" }
variable "azcount" { default="3" type="string" }

data "null_data_source" "my" {
  inputs = {
    newbits = "${max(1 , max( 22 , min(var.netsize + 4 , 28)) - var.netsize)}"
    azs = "${max( 1 , min( length(data.aws_availability_zones.available.names) , var.azcount) )}"
    azlist = "[${list(slice(data.aws_availability_zones.available.names , 0 , max( 1 , min( length(data.aws_availability_zones.available.names) , var.azcount) ) ))}]"
  }
}

data "aws_availability_zones" "available" {}


output "newbits" { value = "${data.null_data_source.my.inputs["newbits"] }" }
output "azs" { value = "${data.null_data_source.my.inputs["azs"] }" }


