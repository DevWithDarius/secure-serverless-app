data "aws_caller_identity" "current" {}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-secure-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_permissions" {
  name = "codebuild-secure-lambda-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:GetFunctionConfiguration"
        ],
        Resource = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:SecureLamdaApi"
      },
      {
        Effect = "Allow",
        Action = [
          "sts:GetCallerIdentity"
        ],
        Resource = "*"
      }
    ]
  })
}
