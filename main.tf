#variable "" { default= type="string" }
variable "region" { default="eu-west-1" type="string" }
variable "costcenter" { type="string" }
variable "nameprefix" { type="string" }
variable "sshkey" { type="string" }
variable "datadog_apikey" { type="string" }

variable "jumphost_ssh_access_cidrs" {
    type = "list"
    default = ["80.76.159.9/32","89.250.119.178/32","195.225.18.0/23"]
}
variable "jumphost_cloudconfig" { default="" type="string" }

variable "netaddr" { default="10.0.0.0" type="string" }
variable "netsize" { default="24" type="string" }
variable "dmzbitz" { default="0" type="string" }
variable "appbitz" { default="0" type="string" }
variable "appnetnumoffsetz" { default="0" type="string" }
variable "appnetflag" { default="true" type="string" }
variable "use_jumphost" { default="true" type="string" }


variable "azs" { default="3" type="string" }
variable "intdns" { default=true type="string" }
variable "intdnszone" { default="" type="string" }

variable "pot2" { type = "list" default = [ "1" , "2" , "4" , "8" ]  }

data "null_data_source" "my" {
  inputs = {
    dmzbits = "${max(1 , min(12 , var.dmzbitz == 0 ? 4 : var.dmzbitz ) ) }"
    appbits = "${max(1 , min(12 , var.appbitz == 0 ? 2 : var.appbitz ) ) }"
    appnetnumoffset = "${max(1, min(8, var.appnetnumoffsetz == 0 ? var.pot2[max(0, min(3, 2 + max(1 , min(12 , var.appbitz == 0 ? 2 : var.appbitz ) ) - max(1 , min(12 , var.dmzbitz == 0 ? 4 : var.dmzbitz ) ) ))] : var.appnetnumoffsetz ))}"
    azcount = "${max( 1 , min( length(data.aws_availability_zones.available.names) , var.azs) )}"
    azlist = "${join(",",slice(data.aws_availability_zones.available.names , 0 , max( 1 , min( length(data.aws_availability_zones.available.names) , var.azs) ) ))}"
    intdnszone = "${var.intdnszone == "" ? "${lower(var.nameprefix)}-${lower(var.costcenter)}.${lower(data.aws_caller_identity.current.account_id)}.local." : var.intdnszone}"
  }
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" { }

data "aws_ami" "bf_rhel7_ebs" {
  most_recent = true
  owners = ["054714998694"]
  filter {
    name = "name"
    values = ["bf-rhel-7*"]
  }
}


output "dmzbits" { value = "${data.null_data_source.my.inputs["dmzbits"] }" }
output "appbits" { value = "${data.null_data_source.my.inputs["appbits"] }" }
output "appnetnumoffset" { value = "${data.null_data_source.my.inputs["appnetnumoffset"] }" }
output "azcount" { value = "${data.null_data_source.my.inputs["azcount"] }" }

#output "azlist" { value = "${list(split(",",data.null_data_source.my.inputs["azlist"]))}" }
output "azlist" { value = "${split(",",data.null_data_source.my.inputs["azlist"])}" }
output "region" { value = "${var.region}" }

