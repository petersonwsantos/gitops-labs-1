# resource "null_resource" "jx_check" {
#   # provisioner "local-exec" {  #   command = "export KUBECONFIG=${var.kubeconfig_dir}/kubeconfig"  # }
#   provisioner "local-exec" {
#     command = "${data.template_file.jenkins_x_check.rendered}"
#   }
# }

