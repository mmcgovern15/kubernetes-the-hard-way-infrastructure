resource "aws_eip" "jumpbox" {
  instance = aws_instance.k8s["jumpbox"].id
  domain   = "vpc"
}

resource "aws_eip" "ngw" {
  domain = "vpc"
}

resource "aws_instance" "k8s" {
  for_each        = local.instances
  ami             = local.latest_bookworm_ami
  instance_type   = "t4g.micro"
  key_name        = local.ssh_key_pair_name
  security_groups = [each.key == "jumpbox" ? local.sg_ids["public"] : local.sg_ids["private"]]
  subnet_id       = each.value.subnet_id

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = local.vpc_id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_nat_gateway" "main_ngw" {
  allocation_id = local.ngw_eip
  subnet_id     = local.subnet_ids["public_1"]

  tags = {
    Name = "main-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_route_table" "private" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.ngw_id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.igw_id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "subnet_rt_association" {
  for_each       = local.subnet_ids
  subnet_id      = local.subnet_ids[each.key]
  route_table_id = strcontains(each.key, "private") ? local.private_rt_id : local.public_rt_id
}

resource "aws_security_group" "k8s" {
  for_each = local.security_group_configs

  name = each.key

  ingress {
    from_port   = each.value.ingress["from_port"]
    to_port     = each.value.ingress["to_port"]
    protocol    = each.value.ingress["protocol"]
    cidr_blocks = strcontains(each.value.ingress["cidr_blocks"][0], "VPC_CIDR") ? [local.vpc_cidr] : each.value.ingress["cidr_blocks"]

  }
  egress {
    from_port   = each.value.egress["from_port"]
    to_port     = each.value.egress["to_port"]
    protocol    = each.value.egress["protocol"]
    cidr_blocks = each.value.egress["cidr_blocks"]
  }

  vpc_id = local.vpc_id

}

resource "aws_subnet" "subnets" {
  for_each = local.subnet_config

  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  vpc_id            = local.vpc_id

  tags = {
    Name = each.key
  }
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "Main"
  }
}
