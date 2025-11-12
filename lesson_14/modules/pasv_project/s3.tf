resource "aws_s3_bucket" "photos" {
  bucket        = var.bucket_name
  force_destroy = true
}

# (Optional) enable default encryption
# resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
#   bucket = aws_s3_bucket.photos.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
#   depends_on = [aws_s3_bucket.photos]
# }

# Create the two logical prefixes by adding empty objects
# resource "aws_s3_object" "prefix_uploads" {
#   bucket = aws_s3_bucket.photos.id
#   key    = "uploads/"
#   source = "/dev/null"
#   etag   = filemd5("/dev/null")

#   depends_on = [aws_s3_bucket.photos]
# }

# resource "aws_s3_object" "prefix_thumbs" {
#   bucket = aws_s3_bucket.photos.id
#   key    = "thumbs/"
#   source = "/dev/null"
#   etag   = filemd5("/dev/null")

#   depends_on = [aws_s3_bucket.photos]
# }
