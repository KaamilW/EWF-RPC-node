provider "aws" {
  region     = "eu-west-1"
  access_key = "xxx"
  secret_key = "xxx"
}

#You can either use already created resources (VPC, Subnets, Internet Gateway or create new ones prior to module usage as below)
# Create VPC

resource "aws_vpc" "ewf_rpc_vpc" {
  cidr_block = "172.32.0.0/24"
  tags = {
    Name = "EWF_VPC"
  }
}

#Create subnet in VPC
resource "aws_subnet" "ewf_subnet" {
  vpc_id                  = aws_vpc.ewf_rpc_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.ewf_rpc_vpc.cidr_block, 4, 15)
  map_public_ip_on_launch = true
}

#Create Internet Gateway for VPC
resource "aws_internet_gateway" "ewf_internet_gw" {
  vpc_id = aws_vpc.ewf_rpc_vpc.id

  tags = {
    Name = "EWF_IGW"
  }
}

#Get VPC Route Table data
data "aws_route_table" "ewf_vpc_route_table" {
  vpc_id = aws_vpc.ewf_rpc_vpc.id
}

#Associate Subnet with VPC Route Rable
resource "aws_route_table_association" "ewf_route_table_subnet" {
  subnet_id      = aws_subnet.ewf_subnet.id
  route_table_id = data.aws_route_table.ewf_vpc_route_table.id
}

#Addd route between Internet Gateway and Internet
resource "aws_route" "ewf_route_table_igw" {
  route_table_id         = data.aws_route_table.ewf_vpc_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ewf_internet_gw.id
}

#Use module to create RPC Node
module "ewf_rpc_prod" {
    source                            = "./ewf_setup_module"
    environment_name                  = "prod"
    ec2_root_volume_size              = 50
    backup_link                       = "https://drive.google.com/uc?id=1ULjWCLgnsleigrWlmrhWo7LptW-Csl0n"
    ec2_instance_type                 = "t3.medium"
    #ip_access_range_ingress_ssh      = "89.64.55.0"
    #cidr_mask_ingress_ssh            = "/24"
    vpc_id                            = aws_vpc.ewf_rpc_vpc.id
    subnet_id                         = aws_subnet.ewf_subnet.id
    internet_gw                       = aws_internet_gateway.ewf_internet_gw
    load_backup                       = true
    name                              = "EWF"
}

#Output node IP address
output "ewf_rpc_ip_prod" {
  value = module.ewf_rpc_prod.ewf_rpc_ec2_ip
}