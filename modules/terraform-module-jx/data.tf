data "template_file" "jx_installation_create" {
  template = "${file("${path.module}/templates/resource-jx_installation-create.tpl")}"

  vars {
    admin_user       = "${var.admin_user}"
    admin_password   = "${var.admin_password}"
    jxprovider       = "${var.jxprovider}"
    git_provider_url = "${var.git_provider_url}"
    git_owner        = "${var.git_owner}"
    git_user         = "${var.git_user}"
    git_token        = "${var.git_token}"
  }
}


data "template_file" "kubernetes_check" {
  template = <<EOF
while  ! kubectl get nodes  ; do
sleep 30
done
EOF

  vars {
    kubeconfig_dir = "${var.kubeconfig_dir}"
  }
}

data "template_file" "jenkins_x_check" {
  template = <<EOF
kubectl config set-context aws --namespace jx
while  ! jx status  ; do
sleep 30
done
echo "JX OK"
EOF

  vars {
    kubeconfig_dir = "${var.kubeconfig_dir}"
  }
}
