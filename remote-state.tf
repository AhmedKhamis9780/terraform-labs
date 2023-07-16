resource "aws_s3_bucket" "lab" {
  bucket = "sprint"

  tags = {
    Name        = "sprint"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "Enabled" {
  bucket = aws_s3_bucket.lab.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_dynamodb_table" "lab" {
  name           = "lock_state"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
terraform {
  backend "s3" {
    bucket = "sprint"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "lock_state"
    encrypt = true

  }

}
