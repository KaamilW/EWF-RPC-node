variable "ec2_instance_type" {
    description = "AWS EC2 instance size"
    default = "t2.micro"
}
variable "ami_name_filter" {
    description = "AWS EC2 AMI search filter"
    default = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}
variable "ami_owner" {
    description = "AWS EC2 AMI owner"
    default = "099720109477"
    type = string
}
variable "ec2_root_volume_size" {
    description = "AWS EC2 root volume size - in GB"
    default = 30
}

variable "environment_name" {
    description = "Type of network you want to set up your node in (test/prod)"
    default = "test"
    type = string

    validation {
        condition = contains(["test","prod"], var.environment_name)
        error_message = "Invalid argument \"environment_name\"."
    }
}

variable "backup_link" {
    description = "Link from which you could download latest avilible snapshot of EWF Blockchain Data"
    default = "https://drive.google.com/uc?id=1MSrU6Wt9-IKio4Ifj4K08bmnVk7M2VWh"
    type = string
}

variable "ip_access_range_ingress_ssh" {
    description = "IP range which should have SSH access to that instance e.g. 88.55.22.219"
    type = string
}

variable "cidr_mask_ingress_ssh" {
    description = "IP mask in CIDR notation for SSH access - e.g. /24 or /32"
    type = string
}

variable "name" {
    description = "Your prefix to be added to resources names"
    type = string
    default = "ewf"
}

variable "load_backup" {
    description = "Variable defining whether load or not backup script"
    type = bool
    default = true
}

variable "vpc_id" {
    description = "VPC id you want to use already existing one"
    type = string
}

variable "subnet_id" {
    description = "Subnet ID you want to use already existing one"
    type = string
}

variable "internet_gw" {
    description = "Internet Gateway Object needed for EC2 dependency"
}

variable "key_pair_name" {
    description = "Name of the key pair to attach to EC2"
}
