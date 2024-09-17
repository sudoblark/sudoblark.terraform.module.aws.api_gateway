locals {
  actual_api_keys = flatten([
    for api in var.raw_api_gateway_rest_apis : [
      for key in api.api_keys : {
        api  = api.suffix
        name = format("%s/%s", api.suffix, key)
      }
    ]
  ])
}

resource "aws_api_gateway_api_key" "api_keys" {
  for_each = { for key in local.actual_api_keys : key.name => key }

  name        = each.value["name"]
  description = format("Automatically generated key for %s API Gateway - managed by Terraform", each.value["api"])
}