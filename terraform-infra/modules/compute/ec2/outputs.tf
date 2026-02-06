#ec2 outputs 
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.my_ec2_instance.id
}
output "ec2_instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.my_ec2_instance.public_ip
}
output "ec2_instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.my_ec2_instance.private_ip
}
output "ec2_instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.my_ec2_instance.arn
}
