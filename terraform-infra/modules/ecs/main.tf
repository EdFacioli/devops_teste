resource "aws_ecs_cluster" "main" {
  name = "${var.environment_id}-cluster"
  tags = {
    Name        = "${var.environment}-ecs"
    Environment = var.environment_id
  }
}