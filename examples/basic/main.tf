terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

output "example" {
  value = "Basic example output"
}
