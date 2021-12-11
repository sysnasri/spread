#############################################################################

# As I am using terraform in CI/CD, so it is a must to have remote state file. 
# I have created an s3 bucket for remote state for my project 

#############################################################################

terraform {
  required_version = ">= 0.13.1"
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.67.0"

    }
  }
}

