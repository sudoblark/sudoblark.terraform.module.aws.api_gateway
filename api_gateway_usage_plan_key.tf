resource "aws_api_gateway_usage_plan_key" "keys" {
  for_each = { for key in local.actual_api_keys : key.name => key }

  key_id        = aws_api_gateway_api_key.api_keys[each.value["name"]].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plans[each.value["api"]].id

  depends_on = [
    aws_api_gateway_usage_plan.usage_plans,
    aws_api_gateway_api_key.api_keys
  ]
}