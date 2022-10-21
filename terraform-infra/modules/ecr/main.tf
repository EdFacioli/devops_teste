resource "aws_ecr_repository" "main" {
  name = var.repository_name
}

# resource "aws_ecr_repository_policy" "main" {
#   repository = aws_ecr_repository.main.name
#   policy     = <<EOF
#   {
#     "Version": "2008-10-17",
#     "Statement": [
#       {
#         "Sid": "adds full ecr access to the test repository",
#         "Effect": "Allow",
#         "Principal": "*",
#         "Action": [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:BatchGetImage",
#           "ecr:CompleteLayerUpload",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:GetLifecyclePolicy",
#           "ecr:InitiateLayerUpload",
#           "ecr:PutImage",
#           "ecr:UploadLayerPart"
#         ]
#       }
#     ]
#   }
#   EOF
# }

resource "aws_ecr_lifecycle_policy" "name" {
  repository = aws_ecr_repository.main.name
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep only 10 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}