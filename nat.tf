resource "aws_eip" "nat" {
  count = "${var.azcount}"
  vpc      = true
#  tags {
#    CostCenter = "${var.costcenter}"
#    Name = "${var.nameprefix}"
#  }
}

resource "aws_nat_gateway" "natgw" {
  count = "${var.azcount}"
  subnet_id = "${element(aws_subnet.dmz.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.igw"]
#  tags {
#    CostCenter = "${var.costcenter}"
#    Name = "${var.nameprefix}"
#  }
}

resource "aws_route_table" "nat" {
  count = "${var.azcount}"
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.natgw.id, count.index)}"
  }
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}"
  }
}

#resource "aws_route" "public" {
#  count = "${var.azcount}"
#  route_table_id = "${element(aws_route_table.public.id, count.index)}"
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = "${element(aws_internet_gateway.igw.id, count.index)}"
#}

output "nat_routing_tables" { value = "${list(aws_route_table.nat.*.id)}" }
output "nat_public_ips" { value = "${list(aws_eip.nat.*.public_ip)}" }

