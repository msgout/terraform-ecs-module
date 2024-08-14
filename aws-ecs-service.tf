# resource "aws_ecs_service" "this" {
#   for_each = var.aws_ecs_service

#   name                               = each.value.name
#   cluster                            = each.value.cluster
#   task_definition                    = each.value.task_definition
#   desired_count                      = each.value.desired_count
#   deployment_minimum_healthy_percent = each.value.deployment_minimum_healthy_percent
#   deployment_maximum_percent         = each.value.deployment_maximum_percent
#   launch_type                        = each.value.launch_type

#   load_balancer {
#     target_group_arn = data.aws_alb_target_group.this2[each.key].arn
#     container_name   = each.value.container_name
#     container_port   = each.value.container_port
#   }

#   network_configuration {
#     security_groups = each.value.security_groups
#     subnets         = each.value.subnets #     assign_public_ip = each.value.assign_public_ip
#   }

#   tags = merge(var.common_tags, { Name = each.value.name })
# }