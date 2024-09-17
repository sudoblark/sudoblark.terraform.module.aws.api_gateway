terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.61.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "restapi_gateway" {
  source = "github.com/sudoblark/sudoblark.terraform.module.aws.api_gateway?ref=1.0.0"

  application_name          = var.application_name
  environment               = var.environment
  raw_api_gateway_rest_apis = local.raw_restapi_gateways

}