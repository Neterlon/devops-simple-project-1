#
# Subnets
#

# Subnets for Kubernetes
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name                             = "${var.project_default_tags.Project}_pub_sub_1a"
    "kubernetes.io/cluster/main_eks" = "shared"
    "kubernetes.io/role/elb"         = 1
  }
}

resource "aws_subnet" "public_2b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name                             = "${var.project_default_tags.Project}_pub_sub_2b"
    "kubernetes.io/cluster/main_eks" = "shared"
    "kubernetes.io/role/elb"         = 1
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name                              = "${var.project_default_tags.Project}_priv_sub_1a"
    "kubernetes.io/cluster/main_eks"  = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private_2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.129.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name                              = "${var.project_default_tags.Project}_priv_sub_2b"
    "kubernetes.io/cluster/main_eks"  = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}


# Subnets for RDS
resource "aws_subnet" "private_3a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.130.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.project_default_tags.Project}_priv_sub_3a"
  }
}

resource "aws_subnet" "private_4b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.131.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.project_default_tags.Project}_priv_sub_4b"
  }
}