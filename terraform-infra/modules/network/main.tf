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

resource "aws_security_group" "main" {
    name        = "full-access-sg"
    description = "Allow all"
    vpc_id      = aws_vpc.main.id

    ingress { // ajustar porta
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}