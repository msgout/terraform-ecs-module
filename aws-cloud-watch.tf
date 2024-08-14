resource "aws_cloudwatch_log_group" "this" {
  for_each = var.aws_cloudwatch_logs

  name              = each.value.name
  retention_in_days = each.value.retention_in_days

  tags = merge(var.common_tags, { Name = each.value.name })
}