resource "aws_eip" "nat" {
  count = "${var.azcount}"
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  count = "${var.azcount}"
  subnet_id = "${element(aws_subnet.dmz.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
}
