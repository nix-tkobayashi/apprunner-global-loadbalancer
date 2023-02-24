variable "aws_region" {
  description = "AWS region to create resources in"
  default     = "ap-northeast-1"
  type        = string
}

variable "auto_scaling_max_concurrency" {
  description = "Maximal number of concurrent requests that you want an instance to process. When the number of concurrent requests goes over this limit, App Runner scales up your service."
  default     = 20
  type        = number
}

variable "auto_scaling_min_size" {
  description = "Minimal number of instances that App Runner provisions for your service."
  default     = 1
  type        = number
}

variable "auto_scaling_max_size" {
  description = "Maximal number of instances that App Runner provisions for your service."
  default     = 5
  type        = number
}

