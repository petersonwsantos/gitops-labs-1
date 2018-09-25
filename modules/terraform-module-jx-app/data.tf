data "template_file" "jx_import_app" {
  template = "${file("${path.module}/templates/jx-import-app.tpl")}"

  vars {
    git_user         = "${var.git_user}"
    git_token        = "${var.git_token}"
    git_provider_url = "${var.git_provider_url}"
    git_organization = "${var.git_organization}"
    git_owner        = "${var.git_owner}"
    app_name         = "${var.app_name}"
  }
}
