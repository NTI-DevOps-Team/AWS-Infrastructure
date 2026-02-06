locals {
  public_subnet = {
    for k, v in var.subnets : k => v if v.public_ip
  }

  private_subnet = {
    for k, v in var.subnets : k => v if !v.public_ip
  }
}
