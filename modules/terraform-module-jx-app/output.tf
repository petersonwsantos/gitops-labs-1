output "import_app" {
  description = "Script for create jenkins-x environment."
  value       = "${data.template_file.jx_import_app.rendered}"
}

# output "repository_url" {
#   description = "Script for create jenkins-x environment."
#   value       = "${data.aws_ecr_repository.registry.repository_url}"
# }

