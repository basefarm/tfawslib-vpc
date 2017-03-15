resource "aws_eip" "nat" {
  count = "${min(2, data.null_data_source.my.inputs["azcount"]) }"
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  count = "${min(2, data.null_data_source.my.inputs["azcount"]) }"
  subnet_id = "${element(aws_subnet.dmz.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_route_table" "nat" {
  count = "${min(2, data.null_data_source.my.inputs["azcount"]) }"
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

resource "aws_route53_record" "nat" {
  count = "${var.intdns ? min(2, data.null_data_source.my.inputs["azcount"]) : 0 }"
   zone_id = "${aws_route53_zone.internal.zone_id}"
   name = "nat${count.index}.${aws_route53_zone.internal.name}"
   type = "A"
   ttl = "300"
   records = ["${element(aws_nat_gateway.natgw.*.private_ip, count.index)}"]
}

output "nat_routing_tables" { value = "${list(aws_route_table.nat.*.id)}" }
output "nat_public_ips" { value = "${list(aws_eip.nat.*.public_ip)}" }
output "nat_internal_hostnames" { value = "${list(aws_route53_record.nat.*.name)}" }

