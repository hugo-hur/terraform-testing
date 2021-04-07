

#Origin access for cloudfront
/*data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    #resources = ["${module.names.s3_endpoint_arn_base}/*"]
    resources = aws_s3_bucket.terraform_example_bucket.s3_endpoint_arn_base

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.terraform_origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    #resources = ["${module.names.s3_endpoint_arn_base}"]
    resources = aws_s3_bucket.terraform_example_bucket.s3_endpoint_arn_base

    principals {
      type        = "AWS"
      #identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
      identifiers = [aws_cloudfront_origin_access_identity.terraform_origin_access_identity.iam_arn]
    }
  }
}*/

locals {
  s3BucketName = "misaka-test-s3-terraform-bucket"
}
resource "aws_s3_bucket" "terraform_example_bucket" {
  bucket = local.s3BucketName
  acl = "private"
  versioning {
    enabled = false
  }
  #policy = #data.aws_iam_policy_document.s3_policy.json
  policy = jsonencode({
      "Version": "2008-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Principal": {
          "AWS": aws_cloudfront_origin_access_identity.terraform_origin_access_identity.iam_arn #"arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity EAF5XXXXXXXXX"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${local.s3BucketName}/*"
      }]
    }
  )
  #tags {
  #  Name = "my-test-s3-terraform-bucket"
  #}

}