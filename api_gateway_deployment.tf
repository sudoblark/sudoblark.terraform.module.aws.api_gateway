resource "aws_api_gateway_deployment" "deployments" {
  for_each = { for api in local.actual_raw_api_gateway_rest_apis : api.suffix => api }

  rest_api_id = aws_api_gateway_rest_api.api_gateway[each.value["suffix"]].id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway[each.value["suffix"]].body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_rest_api.api_gateway
  ]
}