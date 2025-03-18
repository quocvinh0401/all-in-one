terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.90.0"
    }
  }

  backend "s3" {
    bucket = "all-in-one-state"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
    
  }
}
