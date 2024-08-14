resource "aws_lb" "this" {
  for_each = var.alb

  name               = each.value.name
  internal           = each.value.internal
  load_balancer_type = each.value.load_balancer_type

  # Convert security group names to their IDs
  security_groups = [for sg_name in each.value.security_groups_name : data.aws_security_group.this[sg_name].id]

  # Use subnet IDs
  subnets = [for subnet_name in each.value.subnets : data.aws_subnet.this[subnet_name].id]

  enable_deletion_protection       = each.value.enable_deletion_protection
  enable_cross_zone_load_balancing = each.value.enable_cross_zone_load_balancing
  idle_timeout                     = each.value.idle_timeout
  drop_invalid_header_fields       = each.value.drop_invalid_header_fields

  tags = merge(var.common_tags, { Name = each.value.name })

}

resource "aws_alb_target_group" "this" {
  for_each = var.alb_target_groups

  name                 = each.value.name
  port                 = each.value.port
  protocol             = each.value.protocol
  vpc_id               = each.value.vpc_id
  deregistration_delay = each.value.deregistration_delay
  target_type          = each.value.target_type

  health_check {
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    interval            = each.value.health_check.interval
    matcher             = each.value.health_check.matcher
    path                = each.value.health_check.path
    port                = each.value.health_check.port
    protocol            = each.value.health_check.protocol
    timeout             = each.value.health_check.timeout
  }

  tags = merge(var.common_tags, { Name = each.value.name })

  depends_on = [aws_lb.this]
}

resource "aws_alb_listener" "this" {
  for_each = var.alb_listener

  load_balancer_arn = data.aws_lb.this[each.key].arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = each.value.default_action_type
    target_group_arn = data.aws_alb_target_group.this[each.key].arn #"arn:aws:elasticloadbalancing:us-east-2:021891591955:targetgroup/dexco-frontend/55c7ed0610c4d12c"  #data.aws_lb_target_group.this[each.key].arn
  }


  depends_on = [aws_alb_target_group.this]
}






  