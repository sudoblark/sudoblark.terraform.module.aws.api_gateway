locals {
  actual_raw_api_gateway_rest_apis = flatten([
    for api in var.raw_api_gateway_rest_apis : merge(api, {
      open_api_definition = templatefile(api.open_api_file_path, try(api.template_input, {}))
    })
  ])
}

resource "aws_api_gateway_rest_api" "api_gateway" {

  for_each = { for api in local.actual_raw_api_gateway_rest_apis : api.suffix => api }

  name        = format(lower("aws-${var.environment}-${var.application_name}-%s"), each.value["suffix"])
  description = format("%s- managed by Terraform", each.value["description"])
  body        = each.value["open_api_definition"]

  lifecycle {
    create_before_destroy = true
  }
}