module "bucket" {
  source = "ptonini/s3-bucket/aws"
  version = "~> 1.0.0"
  name = var.bucket_name
  bucket_policy_statements = [
    {
      Sid = "AWSCloudTrailAclCheck"
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "s3:GetBucketAcl"
      Resource = "arn:aws:s3:::${var.bucket_name}"
    },
    {
      Sid = "AWSCloudTrailWrite"
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "s3:PutObject"
      Resource = "arn:aws:s3:::${var.bucket_name}/AWSLogs/${var.account_id}/*"
      Condition = {
        StringEquals = {
          "s3:x-amz-acl" = "bucket-owner-full-control"
        }
      }
    }
  ]
  force_destroy = var.force_destroy_bucket
  providers = {
    aws = aws
  }
}

resource "aws_cloudtrail" "this" {
  name = var.name
  s3_bucket_name = module.bucket.this.id
  include_global_service_events = var.include_global_service_events
  depends_on = [
    module.bucket
  ]
}