# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = var.environment_id
    Name        = "${var.environment_id}-main"
  }
}

# Nat Gateway
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.main_public.*.id, 0)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Environment = var.environment_id
    Name        = "${var.environment_id}-main"
  }
}

# Public Route Table
resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }    

  tags = {
    Environment = var.environment_id
    Name        = "${var.environment_id}-public"
  }
}

resource "aws_route_table_association" "main_public" {
  count = var.max_azone != 0 ? var.max_azone : local.azone_count

  route_table_id = aws_route_table.main_public.id
  subnet_id      = element(aws_subnet.main_public.*.id, count.index)
}

# Private Route Table
resource "aws_route_table" "main_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Environment = var.environment_id
    Name        = "${var.environment_id}-private"
  }
}

resource "aws_route_table_association" "main_private" {
  count = var.max_azone != 0 ? var.max_azone : local.azone_count

  route_table_id = aws_route_table.main_private.id
  subnet_id      = element(aws_subnet.main_private.*.id, count.index)
}