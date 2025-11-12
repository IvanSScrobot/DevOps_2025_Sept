# Zip the Lambda source dir
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_src"
  output_path = "${path.module}/lambda_src.zip"
}

# Optional: create a Lambda layer from a prebuilt zip on disk
resource "aws_lambda_layer_version" "pillow" {
  count               = length(var.pillow_layer_zip) > 0 ? 1 : 0
  layer_name          = "${local.name_prefix}-pillow"
  filename            = "${path.module}/${var.pillow_layer_zip}"
  compatible_runtimes = ["python3.12"]
  description         = "Pillow layer built on Amazon Linux 2023"
}

resource "aws_lambda_function" "thumb_maker" {
  function_name = "${var.environment}-${local.name_prefix}-thumb-maker"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.12"
  handler       = "lambda_function.handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.photos.bucket
    }
  }

  layers = length(var.pillow_layer_zip) > 0 ? [aws_lambda_layer_version.pillow[0].arn] : []
}

# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.thumb_maker.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.photos.arn
}

# Wire S3 event to Lambda for uploads/ create events
resource "aws_s3_bucket_notification" "photos_notify" {
  bucket = aws_s3_bucket.photos.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumb_maker.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_s3_bucket.photos, aws_lambda_permission.allow_s3_invoke]
}
