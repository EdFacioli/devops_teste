output "ecr_repository" {
  value = aws_ecr_repository.main.repository_url
}