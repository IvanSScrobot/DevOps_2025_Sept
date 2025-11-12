terraform {
  backend "s3" {
    bucket         = "pasv-course-iskrobot-tf-state-lesson14-stg"
    key            = "staging/pasv_project.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}
