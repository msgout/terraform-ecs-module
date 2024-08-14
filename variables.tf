variable "aws_ecr" {
  description = "Map of ECR repositories to create"
  type = map(object({
    name         = string
    force_delete = bool
    scan_on_push = bool
  }))
}

variable "aws_cloudwatch_logs" {
  description = "Map of CloudWatch log groups to create"
  type = map(object({
    name              = string
    retention_in_days = number
  }))
}

variable "aws_iam_roles" {
  type = map(object({
    name               = string
    assume_role_policy = string
    policy_name_attach = list(string) # Altere para aceitar uma lista de strings
  }))
}

variable "aws_ecs_clusters" {
  description = "Map of ECS clusters to create"
  type = map(object({
    name = string
  }))
}

variable "aws_ecs_service" {
  type = map(object({
    name                               = string
    cluster                            = string
    task_definition                    = string
    desired_count                      = number
    subnets                            = list(string)
    security_groups                    = list(string)
    container_name                     = string
    container_port                     = number
    load_balancer_arn                  = string
    assign_public_ip                   = bool
    deployment_minimum_healthy_percent = string
    deployment_maximum_percent         = string
    launch_type                        = string
  }))
}
###


variable "security_groups" {
  description = "Configuração dos Security Groups"
  type = map(object({
    name        = string
    description = string
    vpc_id      = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "alb" {
  type = map(object({
    name                             = string
    description                      = string
    security_groups_name             = list(string)
    subnets                          = list(string)
    enable_deletion_protection       = bool
    enable_cross_zone_load_balancing = bool
    idle_timeout                     = number
    drop_invalid_header_fields       = bool
    internal                         = bool
    load_balancer_type               = string
  }))
}

variable "alb_target_groups" {
  type = map(object({
    name                 = string
    port                 = number
    protocol             = string
    vpc_id               = string
    deregistration_delay = number
    target_type          = string
    health_check = object({
      healthy_threshold   = number
      unhealthy_threshold = number
      interval            = number
      matcher             = string
      path                = string
      port                = string
      protocol            = string
      timeout             = number
    })
  }))
}


variable "alb_listener" {
  type = map(object({
    load_balancer_name  = string
    port                = number
    protocol            = string
    default_action_type = string
  }))
}

variable "ecs_task_definitions" {
  description = "Map of ECS task definitions with their configuration"
  type = map(object({
    family                = string
    cpu                   = number
    memory                = number
    container_name        = string
    repository_url        = string
    port                  = number
    execution_role        = string
    cloudwatch_log_groups = string
    cloudwatch_log_region = string
    cloudwatch_log_prefix = string
  }))
}



variable "ecs_service_autoscaling" {
  description = "Map of ECS services with their autoscaling configurations"
  type = map(object({
    target = object({
      max_capacity       = number
      min_capacity       = number
      resource_id        = string
      scalable_dimension = string
      service_namespace  = string
    })
    cpu_scaling_policy = object({
      name         = string
      policy_type  = string
      target_value = number
      metric_type  = string
    })
    memory_scaling_policy = object({
      name         = string
      policy_type  = string
      target_value = number
      metric_type  = string
    })
  }))
}

variable "common_tags" {
  description = "Tags comuns para todos os Security Groups"
  type        = map(string)
  default     = {}
}
