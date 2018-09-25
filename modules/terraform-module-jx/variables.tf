variable "jxprovider" {
  default = ""
}

variable "git_provider_url" {
  default = ""
}

variable "git_owner" {
  default = ""
}

variable "git_organization" {
  default = ""
}

variable "git_user" {
  description = "git username "
}

variable "git_email" {
  description = ""
}

variable "git_token" {
  description = "token git"
}

variable "admin_user" {
  description = "Admin username for Jenkins-x"
}

variable "admin_password" {
  description = "Admin password for Jenkins-x"
}

variable "triggers" {
  default = "0"
  type    = "string"
}

variable "kubeconfig_dir" {
  type = "string"
}

variable "cluster_endpoint" {}

variable "worker_iam_role_name" {}

variable "db_connection" {}
