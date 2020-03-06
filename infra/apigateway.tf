resource "aws_api_gateway_rest_api" "website-apigw-rest-api" {
  name = "WildRydes"

  endpoint_configuration {
    types = ["EDGE"]
  }

}

resource "aws_api_gateway_authorizer" "demo" {
  name                   = "WildRydes"
  rest_api_id            = aws_api_gateway_rest_api.website-apigw-rest-api.id
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = [ aws_cognito_user_pool.pool.arn ]
}

resource "aws_api_gateway_resource" "website-apigw-resource" {
  rest_api_id = aws_api_gateway_rest_api.website-apigw-rest-api.id
  parent_id   = aws_api_gateway_rest_api.website-apigw-rest-api.root_resource_id
  path_part   = "ride"
}

resource "aws_api_gateway_method" "website-apigw-ride-post" {
  rest_api_id   = aws_api_gateway_rest_api.website-apigw-rest-api.id
  resource_id   = aws_api_gateway_resource.website-apigw-resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "website-integration" {
  rest_api_id             = aws_api_gateway_rest_api.website-apigw-rest-api.id
  resource_id             = aws_api_gateway_resource.website-apigw-resource.id
  http_method             = aws_api_gateway_method.website-apigw-ride-post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.website_lambda.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.website_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-2:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.website-apigw-rest-api.id}/*/${aws_api_gateway_method.website-apigw-ride-post.http_method}${aws_api_gateway_resource.website-apigw-resource.path}"
}

resource "aws_api_gateway_deployment" "website-apigw-deployment" {
  depends_on = [aws_api_gateway_integration.website-integration]

  rest_api_id = aws_api_gateway_rest_api.website-apigw-rest-api.id
  stage_name  = "prod"

}
resource "aws_api_gateway_stage" "website_prod_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.website-apigw-rest-api.id
  deployment_id = aws_api_gateway_deployment.website-apigw-deployment.id
}

output "website-apigw-deployment-invoke-url" {
    value = aws_api_gateway_deployment.website-apigw-deployment.invoke_url
}