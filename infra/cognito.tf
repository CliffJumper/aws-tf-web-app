resource "aws_cognito_user_pool" "pool" {
  name = "photosite-pool"
}

resource "aws_cognito_user_pool_client" "client" {
  name = "PhotositeWebClient"

  generate_secret = false

  user_pool_id = aws_cognito_user_pool.pool.id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.client.id
}
