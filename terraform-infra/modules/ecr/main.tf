resource "aws_ecr_repository" "main" {
  name = var.repository_name
}

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