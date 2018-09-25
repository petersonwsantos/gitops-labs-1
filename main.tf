
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.37.0"

  name = "vpc-${var.cluster_name}"
  cidr = "10.0.0.0/16"

  azs             = ["${slice(data.aws_availability_zones.available.names, 1, 3)}"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  #single_nat_gateway = true

  tags = "${merge(local.tags, map("kubernetes.io/cluster/${var.cluster_name}", "shared"))}"
}

module "eks" {
  source = "modules/terraform-aws-eks"

  cluster_name              = "${var.cluster_name}"
  subnets                   = "${module.vpc.public_subnets}"
  vpc_id                    = "${module.vpc.vpc_id}"
  worker_groups             = "${local.worker_groups}"
  cluster_version           = "1.10"
  configure_kubectl_session = true
  config_output_path        = "${var.kubeconfig_dir}"
  tags                      = "${local.tags}"
}

module "jx" {
  source = "modules/terraform-module-jx"

  git_token            = "${var.git_token}"
  admin_user           = "${var.admin_user}"
  admin_password       = "${var.admin_password}"
  jxprovider           = "${var.jx_provider}"
  git_provider_url     = "${var.git_provider_url}"
  git_owner            = "${var.git_user}"
  git_user             = "${var.git_user}"
  git_email            = "${var.git_email}"
  git_organization     = "${var.git_user}"
  kubeconfig_dir       = "${var.kubeconfig_dir}"
  cluster_endpoint     = "${module.eks.cluster_endpoint}"
  worker_iam_role_name = "${module.eks.worker_iam_role_name}"
  db_connection        = "postgres://${module.db.this_db_instance_username}:${module.db.this_db_instance_password}@${module.db.this_db_instance_address}/${module.db.this_db_instance_name}"
}

module "jx_app_api" {
  source = "modules/terraform-module-jx-app"

  app_name             = "api"
  git_token            = "${module.jx.this_git_token}"
  git_provider_url     = "${var.git_provider_url}"
  git_owner            = "${var.git_user}"
  git_user             = "${var.git_user}"
  git_organization     = "${var.git_user}"
  kubeconfig_dir       = "${var.kubeconfig_dir}"
  worker_iam_role_name = "${module.eks.worker_iam_role_name}"
  workers_asg_arns     = "${module.eks.workers_asg_arns}"
}

module "jx_app_web" {
  source = "modules/terraform-module-jx-app"

  app_name             = "web"
  git_token            = "${module.jx.this_git_token}"
  git_provider_url     = "${var.git_provider_url}"
  git_owner            = "${var.git_user}"
  git_user             = "${var.git_user}"
  git_organization     = "${var.git_user}"
  kubeconfig_dir       = "${var.kubeconfig_dir}"
  worker_iam_role_name = "${module.eks.worker_iam_role_name}"
  workers_asg_arns     = "${module.eks.workers_asg_arns}"
}

module "sg_db" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["10.0.0.0/16"]

  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = "${local.tags}"
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "1.19.0"

  identifier = "pgdb"

  engine            = "postgres"
  engine_version    = "9.6.3"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  name     = "pgdb"
  username = "stone"

  password               = "stone123"
  port                   = "5432"
  vpc_security_group_ids = ["${module.sg_db.this_security_group_id}"]

  maintenance_window = "Mon:00:00-Mon:01:00"
  backup_window      = "02:00-00:00"

  backup_retention_period = 0
  tags                    = "${local.tags}"

  subnet_ids = ["${module.vpc.public_subnets}"]

  family = "postgres9.6"

  major_engine_version = "9.6"

  final_snapshot_identifier = "pgdb"
}
