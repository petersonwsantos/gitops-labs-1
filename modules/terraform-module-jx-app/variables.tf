variable "git_provider_url" {
  description = ""
  default     = "https://github.com"
}

variable "git_owner" {
  description = ""
}

variable "git_organization" {
  description = ""
}

variable "git_user" {
  description = ""
}

variable "git_token" {
  description = "token git"
}

variable "app_name" {
  description = "Application name"
  type        = "string"
}

variable "kubeconfig_dir" {
  type = "string"
}

variable "worker_iam_role_name" {
  type = "string"
}

variable "workers_asg_arns" {}
