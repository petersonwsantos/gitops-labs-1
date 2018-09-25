variable "region" {
  default = "us-east-1"
}

variable "project" {
  type = "string"
}

variable "bucket_backend" {
  type = "string"
}

variable "key_backend" {
  type = "string"
}

variable "dynamodb_table_backend" {
  type = "string"
}

variable "cluster_name" {
  type = "string"
}

variable "kubeconfig_dir" {
  type = "string"
}

variable "admin_user" {
  type = "string"
}

variable "admin_password" {
  type = "string"
}

variable "jx_provider" {
  type = "string"
}

variable "git_provider_url" {
  type = "string"
}

variable "git_user" {
  type = "string"
}

variable "git_email" {
  type = "string"
}

variable "git_token" {
  type = "string"
}
