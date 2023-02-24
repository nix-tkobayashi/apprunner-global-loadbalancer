locals {
  service_name        = "nginx-loadbalancer"
  ecr_repository_name = "nginx-loadbalancer"
  iam_role_name       = "nginx-loadbalancer"
  iam_policy_name     = "nginx-loadbalancer"

  aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}
