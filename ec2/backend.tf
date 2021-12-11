terraform {
  backend "s3" {
    bucket         = "terraform-state-nasri-projects"
    key            = "terraform-state-key"
    region         = "us-east-1"
    dynamodb_table = "terraform-nasri-project-state"

  }
}
