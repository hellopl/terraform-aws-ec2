terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}


provider "aws" {
    region = var.region

    default_tags {
        tags = {
            env         = "Development"
            owner       = "Pavel Sevko"
            terraform   = "true"
            Name        = "EC2 - task 1 with 2 additional EBS"
        }
    }
}
