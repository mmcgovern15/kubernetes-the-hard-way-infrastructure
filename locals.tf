locals {
  #TFVARS to Locals
  security_group_configs = var.security_group_configs
  ssh_key_pair_name      = var.ssh_key_pair_name
  subnet_config          = var.subnet_config
  vpc_cidr               = var.vpc_cidr

  #Data Source to Locals
  latest_bookworm_ami = data.aws_ami.bookworm.id


  #Resource Reference to Locals
  igw_id = aws_internet_gateway.main_igw.id

  instances = {
    jumpbox = {
      subnet_id = local.subnet_ids["public_1"]
    }
    server = {
      subnet_id = local.subnet_ids["private_1"]
    }
    node-0 = {
      subnet_id = local.subnet_ids["private_2"]
    }
    node-1 = {
      subnet_id = local.subnet_ids["private_3"]
    }
  }

  ngw_eip = aws_eip.ngw.id

  ngw_id = aws_nat_gateway.main_ngw.id

  private_rt_id = aws_route_table.private.id

  public_rt_id = aws_route_table.public.id

  subnet_ids = {
    private_1 = aws_subnet.subnets["private_1"].id
    private_2 = aws_subnet.subnets["private_2"].id
    private_3 = aws_subnet.subnets["private_3"].id
    public_1  = aws_subnet.subnets["public_1"].id
  }

  sg_ids = {
    public  = aws_security_group.k8s["public"].id
    private = aws_security_group.k8s["private"].id
  }

  vpc_id = aws_vpc.main.id

}
