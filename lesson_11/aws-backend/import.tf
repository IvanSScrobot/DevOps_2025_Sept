# Make sure you still have:
# provider "aws" { alias = "state"; region = var.state_region }

import {
  to = aws_s3_bucket.terraform_state
  id = "pasv-course-iskrobot-tf-state"
}

import {
  to = aws_s3_bucket_versioning.terraform_bucket_versioning
  id = "pasv-course-iskrobot-tf-state"
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.terraform_state_crypto_conf
  id = "pasv-course-iskrobot-tf-state"
}

# import {
#   to = aws_s3_bucket_public_access_block.terraform_state_pab
#   id = "pasv-course-iskrobot-tf-state"
# }

import {
  to = aws_dynamodb_table.terraform_locks
  id = "terraform-state-locking"
}
