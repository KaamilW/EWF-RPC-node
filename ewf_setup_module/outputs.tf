output "ewf_rpc_ec2_ip" {
  value = aws_eip.ewf_eip.public_ip
}
