resource "aws_ecs_cluster" "this" {
  for_each = var.aws_ecs_clusters

  name = each.value.name

  tags = merge(var.common_tags, { Name = each.value.name })

  # depends_on = [aws_ecr_repository.this]
}
