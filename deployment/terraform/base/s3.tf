resource "aws_s3_bucket" "blob" {
  bucket = "consume-s3-example"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_access_point" "blob" {
  bucket = aws_s3_bucket.blob.id
  name   = "consume-s3-example"

  vpc_configuration {
    vpc_id = data.aws_vpc.default.id
  }
}