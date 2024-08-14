locals {
  # This flattens a list of subnets obtained from each ALB configuration into a single list and removes duplicates.
  all_subnets = flatten([for alb_key, alb_value in var.alb : alb_value.subnets])

  # Convert the list of all subnets to a set to ensure uniqueness
  unique_subnets = toset(local.all_subnets)

  # Collect all unique security group names from the `alb` variable.
  unique_sg_names = toset(flatten([for key, alb in var.alb : alb.security_groups_name]))

  # Create a list of role and policy combinations from the `ecs_iam_roles` variable.
  role_policy_combinations = flatten([
    for role_key, role_value in var.aws_iam_roles : [
      for policy in role_value.policy_name_attach : {
        role       = role_value.name # IAM role name
        policy_arn = policy          # ARN of the policy attached to the role
      }
    ]
  ])
}
