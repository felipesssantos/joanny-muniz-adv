terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "lp-joanny-muniz-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

# Usando us-east-1 pois é mandatório para certificados ACM no CloudFront futuramente
provider "aws" {
  region = "us-east-1"
}
