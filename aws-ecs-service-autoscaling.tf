# resource "aws_appautoscaling_target" "ecs_target" {
#   for_each           = var.ecs_service_autoscaling
#   max_capacity       = each.value.target.max_capacity
#   min_capacity       = each.value.target.min_capacity
#   resource_id        = each.value.target.resource_id
#   scalable_dimension = each.value.target.scalable_dimension
#   service_namespace  = each.value.target.service_namespace
# }

# resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
#   for_each           = var.ecs_service_autoscaling
#   name               = each.value.cpu_scaling_policy.name
#   policy_type        = each.value.cpu_scaling_policy.policy_type
#   resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target[each.key].scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target[each.key].service_namespace

#   target_tracking_scaling_policy_configuration {
#     target_value = each.value.cpu_scaling_policy.target_value

#     predefined_metric_specification {
#       predefined_metric_type = each.value.cpu_scaling_policy.metric_type
#     }
#   }
# }

# resource "aws_appautoscaling_policy" "ecs_memory_policy" {
#   for_each           = var.ecs_service_autoscaling
#   name               = each.value.memory_scaling_policy.name
#   policy_type        = each.value.memory_scaling_policy.policy_type
#   resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_target[each.key].scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target[each.key].service_namespace

#   target_tracking_scaling_policy_configuration {
#     target_value = each.value.memory_scaling_policy.target_value

#     predefined_metric_specification {
#       predefined_metric_type = each.value.memory_scaling_policy.metric_type
#     }
#   }
# }
