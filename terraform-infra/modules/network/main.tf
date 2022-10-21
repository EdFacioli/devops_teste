data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azone_count = length(data.aws_availability_zones.available.names)
}

resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/16"

  tags = {
    Environment = var.environment_id
    Name        = "${var.environment_id}-main"
  }
}