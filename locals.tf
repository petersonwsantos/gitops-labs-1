locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"

  worker_groups = "${list(
                    map("asg_desired_capacity", "2",
                        "asg_max_size", "3",
                        "asg_min_size", "2",
                        "instance_type", "t2.medium",
                        "key_name", "${var.cluster_name}",
                        "additional_userdata","echo \"{  \\\"insecure-registries\\\" : [ \\\"0.0.0.0:5000\\\" ]  }\" > /etc/docker/daemon.json && sudo /bin/systemctl daemon-reload && /bin/systemctl restart docker.service ",
                        "name", "worker_group_a",
                    ),
  )}"

  tags = "${map("project", "${var.project}",
                "k8s_type", "EKS"
  )}"
}
