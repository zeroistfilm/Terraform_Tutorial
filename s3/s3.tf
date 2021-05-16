provider "aws" {
    region = "ap-northeast-2"
  
}
resource "aws_s3_bucket" "s3" {
}
  bucket = "yd-terraform"