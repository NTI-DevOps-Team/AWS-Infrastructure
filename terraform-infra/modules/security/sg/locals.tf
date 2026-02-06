
locals {
  inbound_rules = merge([
    for sg_key, sg in var.security_group : {
      for rule_key, rule in sg.inbound_rules :
      "${sg_key}-${rule_key}" => {
        sg_key    = sg_key
        protocol  = rule.protocol
        from_port = rule.from_port
        to_port   = rule.to_port
        cidr_ipv4 = rule.cidr_ipv4
      }
    }
  ]...)

  outbound_rules = merge([
    for sg_key, sg in var.security_group : {
      for rule_key, rule in sg.outbound_rules :
      "${sg_key}-${rule_key}" => {
        sg_key    = sg_key
        protocol  = rule.protocol
        from_port = rule.from_port
        to_port   = rule.to_port
        cidr_ipv4 = rule.cidr_ipv4
      }
    }
  ]...)
}
