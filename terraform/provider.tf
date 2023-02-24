terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "docker" {
  registry_auth {
    address  = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}