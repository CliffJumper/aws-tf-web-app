
data "aws_caller_identity" "current" {}

# Lambda-specific IAM Settings
resource "aws_iam_role" "photosite-lambda-role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "photosite-lambda-policy" {
    name = "photosite-lambda-policy"
    role = aws_iam_role.photosite-lambda-role.id

    policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": [
            "dynamodb:PutItem"
            ],
            "Effect": "Allow",
            "Resource": "${aws_dynamodb_table.photosite-dynamodb-table.arn}"
        }
        ]
    }
    EOF
}


resource "aws_iam_role_policy_attachment" "photosite-lambda-role-policy-attach" {
  role       = aws_iam_role.photosite-lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# LAMBDA FUNCTION 
resource "aws_lambda_function" "photosite_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "RequestUnicorn"
  role          = aws_iam_role.photosite-lambda-role.arn
  handler       = "exports.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}