resource "null_resource" "kubernetes_check" {
  provisioner "local-exec" {
    command = "${data.template_file.kubernetes_check.rendered}"
  }

  depends_on = ["null_resource.depends_module_eks"]
}

resource "null_resource" "jx_prep_installation" {
  # configuration git for jx
  provisioner "local-exec" {
    command = "git config --global user.email ${var.git_email}"
  }

  provisioner "local-exec" {
    command = "git config --global user.name ${var.git_user}"
  }

  provisioner "local-exec" {
    command = "git config --global credential.helper cache --replace-all"
  }
}

resource "null_resource" "jx_installation" {
  # installationation jx
  provisioner "local-exec" {
    command = "${data.template_file.jx_installation_create.rendered}"
  }

  # delete jx
  provisioner "local-exec" {
    when        = "destroy"
    command     = "${file("${path.module}/scripts/jx-delete.sh")}"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = ["null_resource.kubernetes_check", "null_resource.jx_prep_installation", "null_resource.depends_module_eks"]
}

resource "null_resource" "jx_check" {
  provisioner "local-exec" {
    command = "${data.template_file.jenkins_x_check.rendered}"
  }

  depends_on = ["null_resource.jx_installation"]
}
