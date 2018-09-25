data "template_file" "kubernetes_check" {
  template = <<EOF
while !  kubectl get nodes ; do
sleep 30
done
echo "Kubernetes oK"
EOF

  vars {
    kubeconfig_dir = "${var.config_output_path}"
  }
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.kubeconfig.rendered}\" >  ${var.config_output_path}/config"
  }
}

resource "null_resource" "kubernetes_check" {
  # provisioner "local-exec" {  #   command = "echo \"${data.template_file.kubeconfig.rendered}\" >  ${var.config_output_path}/config"  # }

  # provisioner "local-exec" {  #   command = "export KUBECONFIG=${var.config_output_path}/kubeconfig"  # }

  provisioner "local-exec" {
    command = "${data.template_file.kubernetes_check.rendered}"
  }

  depends_on = ["null_resource.configure_kubectl", "aws_launch_configuration.workers", "null_resource.configure_kubectl"]
}

resource "null_resource" "cluster" {
  # triggers {  #   version = "${var.triggers}"  # }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.config_output_path}/kubeconfig apply  -f ${path.module}/manifests/"
  }

  depends_on = ["null_resource.kubernetes_check"]
}
