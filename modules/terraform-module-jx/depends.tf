data "template_file" "depends_module_eks" {
  template = <<EOF
echo "$${depends1} $${depends2}"
EOF

  vars {
    depends1 = "${var.cluster_endpoint}"
    depends2 = "${var.worker_iam_role_name}"
  }
}

resource "null_resource" "depends_module_eks" {
  provisioner "local-exec" {
    command = "${data.template_file.depends_module_eks.rendered}"
  }
}
