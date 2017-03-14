# tfawslib-vpc
Terraform module implementing standardized VPC

## Inputs:  
+ variable "region" { type="string" }  
+ variable "costcenter" { type="string" }  
+ variable "nameprefix" { type="string" }  
+ variable "netaddr" { default="10.0.0.0" type="string" }  
+ variable "netsize" { default="24" type="string" }  
+ variable "azs" { default="3" type="string" }  

## Outputs:  
+ "dmznets" - list of subnet ID's for DMZ networks  
+ "igwid" - ID for Internet Gateway  
+ "pubrt" - ID for routing table with direct internet access  
+ "newbits" - additional bits in subnet network mask  
+ "azcount" - adjusted number of availability zones used  
+ "azlist" - list of names of the availability zones used  
+ "nat_routing_tables" - list of routing tables for internet access through NAT gateways  
+ "nat_public_ips" - public IP addresses associated with NAT gateways  
+ "vpcid" - ID of the VPC created  

## Example:


```hcl
variable "region" { default="eu-west-1" }  
variable "costcenter" { default="MyLab" }  
variable "nameprefix" { default="MyTest" }  
  module "vpc" {    source = "git@github.com:basefarm/tfawslib-vpc"  
  region = "${var.region}"  
  costcenter = "${var.costcenter}"  
  nameprefix = "${var.nameprefix}"  
  netsize = 23  
  netaddr = "172.26.16.0"  
  azs = 2  
}
output "VPC ID" { value = "${module.vpc.vpcid}" }  
output "AZ Count" { value = "${module.vpc.azcount}" }  
output "AZ List" { value = "${module.vpc.azlist}" }  
output "Public Route Table" { value = "${module.vpc.pubrt}" }  
output "DMZ Networks" { value = "${module.vpc.dmznets}" }  
output "NAT Routing Tables" { value = "${module.vpc.nat_routing_tables}" }  
output "NATGW Public IPs" { value = "${module.vpc.nat_public_ips}" }  
```
  
  

  
