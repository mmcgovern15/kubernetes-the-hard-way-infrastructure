security_group_configs = {
  public = {
    ingress = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [""] #Enter your IP that you will be SSHing from
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  private = {
    ingress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["VPC_CIDR"]
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

ssh_key_pair_name = "mcg"

subnet_config = {
    public_1 = {
      az   = "us-east-1a"
      cidr = "10.0.0.0/18"
    }
    private_1 = {
      az   = "us-east-1b"
      cidr = "10.0.64.0/18"
    }
    private_2 = {
      az   = "us-east-1c"
      cidr = "10.0.128.0/18"
    }
    private_3 = {
      az   = "us-east-1d"
      cidr = "10.0.192.0/18"
    }
  }

vpc_cidr = "10.0.0.0/16"

