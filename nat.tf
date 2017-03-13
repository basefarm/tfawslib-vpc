resource "aws_eip" "nat" {
  count = "${data.null_data_source.my.inputs["azcount"] }"
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  count = "${data.null_data_source.my.inputs["azcount"] }"
  subnet_id = "${element(aws_subnet.dmz.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_route_table" "nat" {
  count = "${data.null_data_source.my.inputs["azcount"] }"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  }
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}-NAT${count.index}"
    AZ = "${element(split(",",data.null_data_source.my.inputs["azlist"]), count.index)}"
  }
}

output "nat_routing_tables" { value = "${list(aws_route_table.nat.*.id)}" }
output "nat_public_ips" { value = "${list(aws_eip.nat.*.public_ip)}" }

