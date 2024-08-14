# Create security group
resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = each.value.vpc_id

  tags = merge(var.common_tags, { "Name" = each.value.name })
}

# Create ingress rules
resource "aws_security_group_rule" "ingress" {
  for_each = {
    for sg_key, sg_value in var.security_groups :
    sg_key => sg_value.ingress_rules
    if length(sg_value.ingress_rules) > 0
  }

  type              = "ingress"
  security_group_id = aws_security_group.this[each.key].id
  from_port         = each.value[0].from_port
  to_port           = each.value[0].to_port
  protocol          = each.value[0].protocol
  cidr_blocks       = each.value[0].cidr_blocks
}

# Create egress rules
resource "aws_security_group_rule" "egress" {
  for_each = {
    for sg_key, sg_value in var.security_groups :
    sg_key => sg_value.egress_rules
    if length(sg_value.egress_rules) > 0
  }

  type              = "egress"
  security_group_id = aws_security_group.this[each.key].id
  from_port         = each.value[0].from_port
  to_port           = each.value[0].to_port
  protocol          = each.value[0].protocol
  cidr_blocks       = each.value[0].cidr_blocks
}
