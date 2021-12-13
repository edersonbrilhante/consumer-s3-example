
data "aws_vpc" "default" {
  default = true
}

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
// {
// 	"Version": "2012-10-17",
// 	"Statement": [
// 		{
// 			"Sid": "Statement1",
// 			"Principal": {},
// 			"Effect": "Allow",
// 			"Action": [
// 				"s3:GetObject"
// 			],
// 			"Resource": []
// 		}
// 	]
// }

// module "s3_bucket" {
//   source = "terraform-aws-modules/s3-bucket/aws"

//   bucket = "consume-s3-example"
//   acl    = "private"

//   versioning = {
//     enabled = true
//   }

// }