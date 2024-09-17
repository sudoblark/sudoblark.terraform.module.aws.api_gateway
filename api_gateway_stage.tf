resource "aws_api_gateway_stage" "stages" {
  for_each = { for api in local.actual_raw_api_gateway_rest_apis : api.suffix => api }

  deployment_id = aws_api_gateway_deployment.deployments[each.value["suffix"]].id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway[each.value["suffix"]].id
  stage_name    = var.environment
  tags          = each.value["tags"]
}