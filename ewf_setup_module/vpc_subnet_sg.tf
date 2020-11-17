data "external" "my_ip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

resource "aws_security_group" "ewf_rpc_sg" {
  name        = "${var.name}_rpc_sg"
  description = "Allow SSH from your machine, allow inbound 80/443, outbound all"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow input from MY computer SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip_access_range_ingress_ssh != "" ? list(join("",[var.ip_access_range_ingress_ssh, var.cidr_mask_ingress_ssh])) : list(join("", ["${data.external.my_ip.result.ip}", "/32"]))
  }

  ingress {
    description = "Allow access from HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow access from HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping machine in"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}_rpc_sg"
  }
}
