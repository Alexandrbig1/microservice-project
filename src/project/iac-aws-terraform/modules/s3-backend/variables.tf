variable "bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
}
