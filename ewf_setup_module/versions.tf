terraform {
  required_version = ">= 0.13, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.5.0, < 4.0"
    }
    local = {
      source = "hashicorp/local"
    }
    external = {
      source = "hashicorp/external"
    }
  }
}

