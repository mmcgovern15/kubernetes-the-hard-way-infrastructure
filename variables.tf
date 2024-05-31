variable "subnet_config" {
  type = map(
    object({
      az   = string
      cidr = string
    })
)
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "security_group_configs" {
  type = map(object({
      ingress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
      egress = object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })

  }))
}

variable "ssh_key_pair_name" {
  type = string
  default = "k8s-ssh-key"
}