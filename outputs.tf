output "vpc_id" {
  value = aws_vpc.main.id
}

output "lb_subnet_ids" {
  value = aws_subnet.lb.*.id
}

output "eks_subnet_ids" {
  value = aws_subnet.eks.*.id
}

output "db_subnet_ids" {
  value = aws_subnet.db.*.id
}

output "eks_subnet_cidr" {
  value = aws_subnet.eks.*.cidr_block
}

