output "subnets_private" {
  value = aws_subnet.private.*.id
}

output "subnets_public" {
  value = aws_subnet.public.*.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}