#create ec2 instance
resource "aws_instance" "my_ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.ec2_ssh_key
  user_data                   = file(var.bootstrap_script)

  tags = {
    Name = "${var.instance_name}_ec2_instance"
  }
}
