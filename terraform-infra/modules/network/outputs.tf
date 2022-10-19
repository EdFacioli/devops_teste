output "sg_id" {
  value = aws_security_group.main.id
}

output "subnets_private" {
  value = aws_subnet.main_private.*.id
}

output "subnets_public" {
  value = aws_subnet.main_public.*.id
}