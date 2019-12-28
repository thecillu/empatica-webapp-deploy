# s3 Bucket with Website settings
resource "aws_s3_bucket" "webapp_bucket" {
  bucket = "${var.webapp_bucket}"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_iam_role" "empatica-webapp-role" {
  name = "empatica-webapp-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "empatica-webapp-policy" {
  role = aws_iam_role.empatica-webapp-role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": [
          "arn:aws:s3:::${var.webapp_bucket}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "iam:PassRole"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "empatica-webapp-build" {
  name          = "empatica-webapp-build"
  description   = "build job for empatica webapp"
  build_timeout = "5"
  service_role  = aws_iam_role.empatica-webapp-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "mlaurie/aws-angular-builder:latest"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

     environment_variable {
      name  = "WEBAPP_BUCKET"
      value = var.webapp_bucket
    }

     environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

  }

  source {
    type            = "GITHUB"
    location        = var.github_url
    git_clone_depth = 1
  }

}

