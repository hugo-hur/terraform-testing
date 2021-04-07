resource "aws_iam_role" "terraform_iam_role_for_lambda" {
    name = "terraform_iam_role_for_lambda"
    #Allow cloudwatch logs etc here


    inline_policy {
        name = "allow_cloudwatch_log_write"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],
                    Effect   = "Allow"
                    "Resource" = "*"
                }
            ]
        })
    }

    inline_policy {
        name = "allow_sqs_read"

        policy = jsonencode({
            Version = "2012-10-17"
            Statement = [
                {
                    Action   = ["sqs:ReceiveMessage","sqs:DeleteMessage","sqs:GetQueueAttributes"]
                    Effect   = "Allow"
                    Resource = aws_sqs_queue.terraform_queue.arn #"*"
                }
            ]
        })
    }

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

resource "aws_lambda_function" "test_lambda" {
  filename      = "HelloWorldLambda.zip"
  function_name = "terraform_hello_world_lambda"
  role          = aws_iam_role.terraform_iam_role_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("HelloWorldLambda.zip")

  runtime = "python3.8"

  /*environment {
    variables = {
      foo = "bar"
    }
  }*/
}