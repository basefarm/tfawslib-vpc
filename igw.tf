resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
    tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}"
    }
}

resource "aws_route" "public" {
    route_table_id = "${aws_route_table.public.id"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
    depends_on = ["aws_route_table.public","aws_internet_gateway.igw"]
}

output "igwid" { value = "${aws_internet_gateway.igw.id}" }
output "pubrt" { value ="${aws_route_table.public.id}" }
