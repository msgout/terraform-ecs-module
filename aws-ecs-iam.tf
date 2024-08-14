resource "aws_iam_role" "this" {
  for_each = var.aws_iam_roles

  name               = each.value.name
  assume_role_policy = file("policies/${each.value.assume_role_policy}")

  tags = merge(var.common_tags, { Name = each.value.name })

  depends_on = [aws_ecr_repository.this]
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for idx, combination in local.role_policy_combinations : "${combination.role}-${combination.policy_arn}" => combination
  }

  role       = each.value.role
  policy_arn = each.value.policy_arn

  depends_on = [aws_iam_role.this]
}