resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform-example-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  #redrive_policy = jsonencode({
  #  deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
  #  maxReceiveCount     = 4
  #})

  tags = {
    Environment = "production"
  }
}

# Event source from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.terraform_queue.arn #"${var.terraform_queue_arn}"
  enabled          = true
  #function_arn     = aws_lambda_function.test_lambda.arn
  function_name    = aws_lambda_function.test_lambda.arn
  #"aws_lambda_function" "test_lambda"
  batch_size       = 1
}