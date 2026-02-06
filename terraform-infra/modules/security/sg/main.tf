
# create Security Group
resource "aws_security_group" "vpc_sg" {
  for_each    = var.security_group
  name        = "${each.value.name}_sg"
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = {
    Name = "${each.value.name}_sg"
  }
}
# Ingress rule to allow inbound traffic within the security group
resource "aws_vpc_security_group_ingress_rule" "inbound_rules" {
  for_each          = local.inbound_rules
  security_group_id = aws_security_group.vpc_sg[each.value.sg_key].id
  from_port         = each.value.protocol == "-1" ? null : each.value.from_port
  to_port           = each.value.protocol == "-1" ? null : each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_ipv4
}
# Egress rule to allow outbound traffic within the security group
resource "aws_vpc_security_group_egress_rule" "outbound_rules" {
  for_each          = local.outbound_rules
  security_group_id = aws_security_group.vpc_sg[each.value.sg_key].id
  from_port         = each.value.protocol == "-1" ? null : each.value.from_port
  to_port           = each.value.protocol == "-1" ? null : each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_ipv4
}

