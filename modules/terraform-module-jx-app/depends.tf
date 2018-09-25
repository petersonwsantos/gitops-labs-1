data "template_file" "depends_module_eks" {
  template = <<EOF
echo "$${depends}"
EOF

  vars {
    depends = "${var.worker_iam_role_name}"
  }
}

resource "null_resource" "depends_module_eks" {
  provisioner "local-exec" {
    command = "${data.template_file.depends_module_eks.rendered}"
  }
}
