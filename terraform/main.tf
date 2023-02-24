# Docker & ECR                                                                          #
resource "aws_ecr_repository" "nginx" {
  name = local.ecr_repository_name
}

resource "docker_registry_image" "nginx" {
  name = docker_image.nginx.name

  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "./../apps/*") : filesha1(f)]))
  }
}

resource "docker_image" "nginx" {
  name = "${aws_ecr_repository.nginx.repository_url}:latest"
  build {
    context = "${path.module}/../apps"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "./../apps/*") : filesha1(f)]))
  }
}

# App Runner                                                                   #
resource "aws_apprunner_auto_scaling_configuration_version" "nginx" {
  auto_scaling_configuration_name = "nginx"

  max_concurrency = var.auto_scaling_max_concurrency
  min_size        = var.auto_scaling_min_size
  max_size        = var.auto_scaling_max_size
}

resource "aws_apprunner_service" "nginx" {
  service_name                   = local.service_name
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.nginx.arn

  source_configuration {
    image_repository {
      image_repository_type = "ECR"
      image_identifier      = docker_registry_image.nginx.name

      image_configuration {
        port = "80"
      }
    }

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner.arn
    }
  }
}

# IAM Role for App Runner                                            #
resource "aws_iam_role" "apprunner" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.apprunner_assume.json
}

data "aws_iam_policy_document" "apprunner_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "build.apprunner.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "apprunner" {
  role       = aws_iam_role.apprunner.name
  policy_arn = aws_iam_policy.apprunner_custom.arn
}

resource "aws_iam_policy" "apprunner_custom" {
  name   = local.iam_policy_name
  policy = data.aws_iam_policy_document.apprunner_custom.json
}

data "aws_iam_policy_document" "apprunner_custom" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
    ]

    resources = [
      "*",
    ]
  }
}

