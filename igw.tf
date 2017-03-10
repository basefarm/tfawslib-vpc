resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}"
  }
}

output "igwid" { value = "${aws_internet_gateway.igw.id}" }
