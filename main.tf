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


output "subsize" { value = "${data.null_data_source.my.inputs["subsize"] }" }
