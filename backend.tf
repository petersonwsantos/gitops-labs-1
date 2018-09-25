terraform {
  backend "s3" {}
}

data "terraform_remote_state" "state" {
  backend = "s3"

  config {
    encrypt                = true
    bucket                 = "${var.bucket_backend}"         #"${aws_s3_bucket.backend_s3.bucket}"
    dynamodb_table         = "${var.dynamodb_table_backend}" #"${aws_dynamodb_table.dynamodb_terraform_state_lock.name}"
    region                 = "${var.region}"
    key                    = "${var.key_backend}"
    skip_region_validation = "true"
  }
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "${var.dynamodb_table_backend}"
  hash_key       = "LockID"
  read_capacity  = 6
  write_capacity = 6

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
