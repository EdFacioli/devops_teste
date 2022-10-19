resource "aws_subnet" "main_public" {
  count = var.max_azone != 0 ? var.max_azone : local.azone_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)   

  tags = {
    Environment = var.environment_id
    Name        = "${var.environment_id}-public-${count.index + 1}"
    Tier        = "public"
  }
}

resource "aws_subnet" "main_private" {
  count = var.max_azone != 0 ? var.max_azone : local.azone_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + local.azone_count)
  map_public_ip_on_launch = false
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)   

  tags = {
    Environment = var.environment_id
    Name        = "${var.environment_id}-private-${count.index + 1}"
    Tier        = "private"
  }
}