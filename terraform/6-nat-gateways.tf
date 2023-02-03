#
# NAT Gateways
#

resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_1a.id
  tags = {
    Name = "${var.project_default_tags.Project}_nat_gw_1"
  }
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public_2b.id
  tags = {
    Name = "${var.project_default_tags.Project}_nat_gw_2"
  }
}

