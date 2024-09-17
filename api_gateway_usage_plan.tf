resource "aws_api_gateway_usage_plan" "usage_plans" {
  for_each = { for api in local.actual_raw_api_gateway_rest_apis : api.suffix => api }

  name        = format("%s-usage-plan", each.value["suffix"])
  description = format("API Gateway usage plan for %s - managed by Terraform", each.value["suffix"])

  api_stages {
    api_id = aws_api_gateway_rest_api.api_gateway[each.value["suffix"]].id
    stage  = aws_api_gateway_stage.stages[each.value["suffix"]].stage_name
  }

  quota_settings {
    limit  = try(each.value["quota_limit"], 10)
    offset = try(each.value["quota_offset"], 0)
    period = try(each.value["quota_period"], "DAY")
  }

  throttle_settings {
    burst_limit = try(each.value["burst_limit"], 5)
    rate_limit  = try(each.value["rate_limit"], 10)
  }

  depends_on = [
    aws_api_gateway_rest_api.api_gateway,
    aws_api_gateway_stage.stages
  ]
}