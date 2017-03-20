resource "aws_instance" "jumphost" {
  count = "${var.use_jumphost == "true" ? 1 : 0}"
  ami = "${data.aws_ami.bf_rhel7_ebs.image_id}"
  instance_type = "t2.micro"
  key_name = "${var.sshkey}"
  monitoring = true
#         private_ip = "${cidrhost(aws_subnet.dmz.cidr_block, 7)}"
  vpc_security_group_ids = [ "${aws_security_group.jumphost_inbound.id}",
                           , "${aws_security_group.unrestricted_egress.id}" ]
  subnet_id = "${aws_subnet.dmz.0.id}"
#    user_data = "${data.template_file.bf_rhel7_imagehost_cloud_config.*.rendered[count.index]}"
  tags {
    CostCenter = "${var.costcenter}"
    Name = "${var.nameprefix}_jumphost"
  }
  user_data = "${var.jumphost_cloudconfig == "" ? data.template_file.jumphost_cloud_config.rendered : var.jumphost_cloudconfig}"
}

data "template_file" "jumphost_cloud_config" {
#  template = "${file("./jumphost_cloudconfig.yml")}"
  template = "#!/bin/bash\n/opt/basefarm/bin/bootstrap --diskdev=xvdc --mountpoint=data --sshkeys --datadog=$${datadog_api_key}"
  vars {
    node_type = "jumphost"
    datadog_api_key = "${var.datadog_apikey}"
  }
}

resource "aws_ebs_volume" "jumphost-data" {
  availability_zone = "${aws_subnet.dmz.0.availability_zone}"
  size = 1
  tags { Name = "${var.nameprefix}_jumphost_data"
         CostCenter = "${var.costcenter}" }
}
resource "aws_volume_attachment" "jumphost-data" {
  device_name = "/dev/xvdc"
  volume_id = "${aws_ebs_volume.jumphost-data.id}"
  instance_id = "${aws_instance.jumphost.id}"
}

resource "aws_eip" "jumphost" {
  count = "${var.use_jumphost == "true" ? 1 : 0}"
  vpc   = true
}
resource "aws_eip_association" "jumphost" {
  count         = "${var.use_jumphost == "true" ? 1 : 0}"
  instance_id   = "${aws_instance.jumphost.id}"
  allocation_id = "${aws_eip.jumphost.id}"
}

resource "aws_security_group" "jumphost_accessible" {
  count        = "${var.use_jumphost == "true" ? 1 : 0}"
  name         = "jumphost_accessible"
  description  = "Allow SSH from jumphost"
  vpc_id        = "${aws_vpc.vpc.id}"
  tags {
    CostCenter = "${var.costcenter}"
    Name       = "${var.nameprefix}_jumphost_accessible"
  }
}
resource "aws_security_group_rule" "jumphost_accessible_01" {
  count             = "${var.use_jumphost == "true" ? 1 : 0}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.jumphost.private_ip}/32"]
  security_group_id = "${aws_security_group.jumphost_accessible.id}"
}

resource "aws_security_group" "jumphost_inbound" {
  count        = "${var.use_jumphost == "true" ? 1 : 0}"
  name         = "jumphost_inbound"
  description  = "Allow inbound SSH to jumphost"
  vpc_id        = "${aws_vpc.vpc.id}"
  tags {
    CostCenter = "${var.costcenter}"
    Name       = "${var.nameprefix}_jumphost_inbound"
  }
}
resource "aws_security_group_rule" "jumphost_inbound_01" {
  count             = "${var.use_jumphost == "true" ? 1 : 0}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.jumphost_ssh_access_cidrs}"]
  security_group_id = "${aws_security_group.jumphost_inbound.id}"
}

output "jumphost_eip" { value = "${aws_eip.jumphost.public_ip}" }
output "jumphost_sg" { value = "${aws_security_group.jumphost_accessible.id}" }