resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "UserDatabase"
  billing_mode   = "PAY_PER_REQUEST"
  #read_capacity  = 20
  #write_capacity = 20
  hash_key       = "username"
  

  attribute {
    name = "username"
    type = "S"
  }
  #attribute {
  #  name = "TimeToExist"
  #  type = "N"
  #}

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "staging",
    Terraform   = "true"
  }
}
