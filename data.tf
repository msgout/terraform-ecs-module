# # Data sources to retrieve subnets by their tag name.
data "aws_subnet" "this" {
  for_each = { for subnet_name in local.unique_subnets : subnet_name => subnet_name }

  filter {
    name   = "tag:Name"
    values = [each.value]
  }
}

# # # Create a data source for each unique security group name.
data "aws_security_group" "this" {
  for_each = local.unique_sg_names

  name = each.value

  depends_on = [aws_security_group.this]
}

# # Data source to retrieve IAM roles based on their names.
data "aws_iam_role" "roles" {
  for_each = { for key, value in var.ecs_task_definitions : key => value.execution_role }
  name     = each.value

  depends_on = [aws_iam_role.this, aws_iam_role_policy_attachment.this]
}

# # Data source to retrieve CloudWatch log groups by their names.
data "aws_cloudwatch_log_group" "log_groups" {
  for_each = { for k, v in var.ecs_task_definitions : k => v.cloudwatch_log_groups }

  name = each.value

  depends_on = [aws_cloudwatch_log_group.this]
}

# # Data source to retrieve ECR repositories by their names.
# data "aws_ecr_repository" "ecr" {
#   for_each = { for td in var.ecs_task_definitions : td.repository_url => td.repository_url }

#   name = each.key
# }

# # # Data source to retrieve Load Balancers based on their names.
data "aws_lb" "this" {
  for_each = {
    for k, v in var.alb_listener :
    k => v.load_balancer_name
  }

  name = each.value

  depends_on = [aws_security_group.this]
}

# # # Data source to retrieve Load Balancer target groups based on their names.
data "aws_alb_target_group" "this" {
  for_each = {
    for k, v in var.alb_listener :
    k => v.load_balancer_name
  }

  name = each.value

  depends_on = [aws_alb_target_group.this]
}

# Data block para recuperar o ALB Target Group com base no nome do serviço ECS
data "aws_alb_target_group" "this2" {
  for_each = var.aws_ecs_service

  name = each.value.name # Nome do Target Group baseado no nome do serviço ECS

  depends_on = [aws_alb_target_group.this]
}

