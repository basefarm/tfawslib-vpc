resource "aws_subnet" "dmz" {
  count = "${data.null_data_source.my.inputs["azcount"] }"
  vpc_id = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = false
  cidr_block = "${cidrsubnet(aws_vpc.vpc.cidr_block,data.null_data_source.my.inputs["newbits"],count.index + 0)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}-DMZ${count.index}"
  }
}

resource "aws_route_table_association" "dmz" {
  count = "${data.null_data_source.my.inputs["azcount"] }"
  subnet_id = "${element(aws_subnet.dmz.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

output "dmznets" { value = "${list(aws_subnet.dmz.*.id)}" }
