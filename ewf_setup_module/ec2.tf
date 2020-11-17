
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }
  owners = [var.ami_owner]
}

resource "aws_instance" "ewf_rpc_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  key_name               = "EWTPem"
  instance_type          = var.ec2_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ewf_rpc_sg.id]
  tags = {
    Name = "${var.name}_RPC"
  }
  depends_on = [var.internet_gw]
  user_data  = join("\n",[local.installation_script, local.backup_script])
  root_block_device {
    volume_size = var.ec2_root_volume_size
  }
}

resource "aws_eip" "ewf_eip" {
  vpc = true
}

resource "aws_eip_association" "ewf_rpc_association" {
  instance_id   = aws_instance.ewf_rpc_ec2.id
  allocation_id = aws_eip.ewf_eip.id
}

