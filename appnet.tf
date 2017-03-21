resource "aws_subnet" "appnet" {
  count = "${var.appnetflag == "true" ? data.null_data_source.my.inputs["azcount"] : 0}"
  vpc_id = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = false
  cidr_block = "${cidrsubnet(aws_vpc.vpc.cidr_block,data.null_data_source.my.inputs["appbits"],count.index + data.null_data_source.my.inputs["appnetnumoffset"] )}"
  availability_zone = "${element(split(",",data.null_data_source.my.inputs["azlist"]), count.index)}"
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}-AppNet${count.index}"
    AZ = "${element(split(",",data.null_data_source.my.inputs["azlist"]), count.index)}"
  }
}

resource "aws_route_table_association" "appnet" {
  count = "${var.appnetflag == "true" ? data.null_data_source.my.inputs["azcount"] : 0}"
  subnet_id = "${element(aws_subnet.appnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.nat.*.id, min(2, count.index) )}"
}

output "appnets" { value = ["${aws_subnet.appnet.*.id}"] }
