provider "http" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "aws" {
  version                = "~> 1.27.0"
  skip_region_validation = "true"
  region                 = "${var.region}"
}

resource "aws_key_pair" "ssh" {
  key_name   = "${var.cluster_name}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
