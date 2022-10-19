resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment_id}-cluster"
  tags = {
    Name        = "${var.app_name}-ecs"
    Environment = var.environment_id
  }
}