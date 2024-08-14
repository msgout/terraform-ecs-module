#  resource "aws_ecs_task_definition" "this" {
#    for_each = var.ecs_task_definitions

#    family                   = each.value.family
#    network_mode             = "awsvpc"
#    requires_compatibilities = ["FARGATE"]

#    cpu    = each.value.cpu
#    memory = each.value.memory

#    execution_role_arn = data.aws_iam_role.roles[each.key].arn

#    container_definitions = jsonencode([{
#      name  = each.value.container_name
#      image = "021891591955.dkr.ecr.us-east-2.amazonaws.com/dexco-frontend:88e9f6601df99f511645069018e81698ec75e24c"

#      essential = true
#      portMappings = [
#        {
#          containerPort = each.value.port
#          hostPort      = each.value.port
#          protocol      = "tcp"
#        }
#      ]
#      logConfiguration = {
#        logDriver = "awslogs"
#        options = {
#          awslogs-group         = data.aws_cloudwatch_log_group.log_groups[each.key].name
#          awslogs-region        = each.value.cloudwatch_log_region
#          awslogs-stream-prefix = each.value.cloudwatch_log_prefix
#        }
#      }
#    }])

#    tags = merge(var.common_tags, { Name = each.value.container_name })

#    # depends_on = [aws_ecs_cluster.this, aws_security_group.this, aws_security_group_rule.egress, aws_security_group_rule.ingress]
#  }