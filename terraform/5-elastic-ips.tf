#
# Elastic IPs
#

resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "${var.project_default_tags.Project}_eip_nat1"
  }
}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "${var.project_default_tags.Project}_eip_nat2"
  }
}