locals {
  actual_lambda_permissions = flatten([
    for api in local.actual_raw_api_gateway_rest_apis : [
      for lambda in api.allowed_lambdas : [
        {
          key : format("%s/%s/stage", api.suffix, lambda)
          function_name : lambda
          source_arn : format("%s/*", aws_api_gateway_stage.stages[api.suffix].arn)
          statement_id = format("AllowExecutionFrom%sAPIGatewayStage", replace(api.suffix, "-", ""))
        },
        {
          key : format("%s/%s/api", api.suffix, lambda)
          function_name : lambda
          source_arn : format("%s/*", aws_api_gateway_rest_api.api_gateway[api.suffix].arn)
          statement_id = format("AllowExecutionFrom%sAPIGateway", replace(api.suffix, "-", ""))
        },
        {
          key : format("%s/%s/deployment", api.suffix, lambda)
          function_name : lambda
          source_arn : format("%s*", aws_api_gateway_deployment.deployments[api.suffix].execution_arn)
          statement_id = format("AllowExecutionFrom%sAPIGatewayDeployment", replace(api.suffix, "-", ""))
        }
      ]
    ]
  ])
}

resource "aws_lambda_permission" "allow_execution" {
  for_each = { for permission in local.actual_lambda_permissions : permission.key => permission }

  depends_on = [
    aws_api_gateway_stage.stages,
    aws_api_gateway_rest_api.api_gateway,
    aws_api_gateway_deployment.deployments
  ]

  statement_id  = each.value["statement_id"]
  action        = "lambda:InvokeFunction"
  function_name = each.value["function_name"]
  principal     = "apigateway.amazonaws.com"
  source_arn    = each.value["source_arn"]
}