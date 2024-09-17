locals {
  raw_restapi_gateways = [
    {
      suffix = "demoapi"
      open_api_file_path : "${path.module}/files/petstore.yaml",
      description = "DemoAPI for example purposes, utilising a remote OpenAPI definition file."
      allowed_lambdas = [
        "auth-lambda",
        "backend-lambda"
      ]
      api_keys = [
        "user1",
        "user2",
        "user3"
      ]
    }
  ]
}