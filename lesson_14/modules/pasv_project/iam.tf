# ---------- EC2 role with S3 access ----------
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.environment}-${local.name_prefix}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_s3_policy" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.photos.arn]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.photos.arn}/*"]
  }
}

resource "aws_iam_policy" "ec2_s3" {
  name   = "${var.environment}-${local.name_prefix}-ec2-s3"
  policy = data.aws_iam_policy_document.ec2_s3_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}-${local.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ---------- Lambda role with S3 + logs ----------
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.environment}-${local.name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }

  statement {
    actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.photos.arn,
      "${aws_s3_bucket.photos.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.environment}-${local.name_prefix}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
