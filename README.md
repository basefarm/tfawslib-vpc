# tfawslib-vpc
Terraform module implementing standardized VPC

Inputs:  
variable "region" { type="string" }  
variable "costcenter" { type="string" }  
variable "nameprefix" { type="string" }  
variable "netaddr" { default="10.0.0.0" type="string" }  
variable "netsize" { default="24" type="string" }  
variable "azs" { default="3" type="string" }  

Outputs:  
"dmznets" - list of subnet ID's for DMZ networks  
"igwid" - ID for Internet Gateway  
"pubrt" - ID for routing table with direct internet access  
"newbits" - additional bits in subnet network mask  
"azcount" - adjusted number of availability zones used  
"azlist" - list of names of the availability zones used  
"nat_routing_tables" - list of routing tables for internet access through NAT gateways  
"nat_public_ips" - public IP addresses associated with NAT gateways  
"vpcid" - ID of the VPC created  
