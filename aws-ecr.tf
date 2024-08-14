resource "aws_ecr_repository" "this" {
  for_each = var.aws_ecr

  name         = each.value.name
  force_delete = each.value.force_delete

  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  tags = merge(var.common_tags, { Name = each.value.name })
}