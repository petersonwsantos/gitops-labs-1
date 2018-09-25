output "this_module" {
  description = "helps dependency between modules"
  value       = "jenkins-x"
}

# data "template_file" "jx_environment_create_development" {
#   template = "${file("${path.module}/templates/jx-environment.tpl")}"

#   vars {
#     git_provider_url      = "${var.git_provider_url}"
#     git_user              = "${var.git_user}"
#     git_token             = "${var.git_token}"
#     environment           = "development"
#     environment_promotion = "auto"
#     db_connection         = "${var.db_connection}"
#   }
# }

# output "env_development" {
#   description = "Script for create jenkins-x environment."
#   value       = "${data.template_file.jx_environment_create_development.rendered}"
# }

data "template_file" "jx_environment_create_staging" {
  template = "${file("${path.module}/templates/jx-environment.tpl")}"

  vars {
    git_provider_url      = "${var.git_provider_url}"
    git_user              = "${var.git_user}"
    git_token             = "${var.git_token}"
    environment           = "staging"
    environment_promotion = "auto"
    db_connection         = "${var.db_connection}"
  }
}

output "env_staging" {
  description = "Script for create jenkins-x environment."
  value       = "${data.template_file.jx_environment_create_staging.rendered}"
}

data "template_file" "jx_environment_create_production" {
  template = "${file("${path.module}/templates/jx-environment.tpl")}"

  vars {
    git_provider_url      = "${var.git_provider_url}"
    git_user              = "${var.git_user}"
    git_token             = "${var.git_token}"
    environment           = "production"
    environment_promotion = "manual"
    db_connection         = "${var.db_connection}"
  }
}

output "env_production" {
  description = "Script for create jenkins-x environment."
  value       = "${data.template_file.jx_environment_create_production.rendered}"
}

data "template_file" "jx_token" {
  template = "${file("${path.module}/templates/jx-token.tpl")}"

  vars {
    admin_user     = "${var.admin_user}"
    admin_password = "${var.admin_password}"
    git_user       = "${var.git_user}"
    git_token      = "${var.git_token}"
  }
}

output "token" {
  description = "Script for create jenkins-x environment."
  value       = "${data.template_file.jx_token.rendered}"
}

locals {
  git_token = "${var.git_token}"
}

output "this_git_token" {
  description = "help dependency between modules"
  value       = "${local.git_token}"
}
