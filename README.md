## Description
Terraform Module to quickly create EWF RPC Node on AWS.

This module:

  - Sets up Ubuntu 18.04 EC2 instance
  - Configures Security Groups:
    - Inbound:
      - 80 & 443 TCP from 0.0.0.0/0
      - 22 TCP from IP you provided (IP and mask in CIDR notation)
      - 8-0 ICMP from 0.0.0.0/0 (for pinging purposes)
    - Outbound:
      - All ports for all protocols for 0.0.0.0/0   

  - Associates Elastic IP with EC2
  - Preconfigures Energy Web Foundation RPC node for either test/prod network (based on https://github.com/energywebfoundation/ewf-rpc)
  - Downloads chain snapshot to speed up sync with a chain

Snapshot link can be found here: https://energyweb.atlassian.net/wiki/spaces/EWF/pages/1013153839/How+to+use+ready-to-go+chain+backup
Sometimes snapshot links does not work - and therefore node will start sync with the network starting from first block.

Please keep in mind that RPC node provisioning can take a few (5-10) minutes.

By default, it sets up an t2.micro EC2 instance with 30GB storage and configures node for Volta (test) network and DOES try to download chain snapshot.

## Prerequisities

- AWS Account and user generated with proper permissions for resources manipulation (Security Groups, Route Tables, EC2, Elastic IP) or admin permissions for simplicity.

- Key pair generated to be associated with EC2 for debuging purposes (EC2 -> Key Pair -> Create Key Pair)

- Terraform installed on your machine (https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Examples
Sample example can be found in [example](./ewf_setup_module/example) subfolder.

```hcl
module "ewf_rpc_prod" {
    source                            = "./ewf_setup_module"
    environment_name                  = "prod"
    ec2_root_volume_size              = 50
    backup_link                       = "https://drive.google.com/uc?id=1ULjWCLgnsleigrWlmrhWo7LptW-Csl0n"
    ec2_instance_type                 = "t3.medium"
    ip_access_range_ingress_ssh       = "89.64.55.0"
    cidr_mask_ingress_ssh             = "/24"
    vpc_id                            = "vpc-01e713fc4920a8666"
    subnet_id                         = "subnet-04782249f892f6b22"
    load_backup                       = true
    name                              = "EWF"
    key_pair_name                     = "EWFKey"
}


```

### Validation
You could validate whether your node is set up via running some JSON RPC requests agains your machine public IP on port 80.
Example requests could be found here: https://openethereum.github.io/wiki/JSONRPC-eth-module 

## TODOs
- HTTPS
- HA
- Observability

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13, < 0.14 |
| aws | >= 3.5.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.5.0, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami\_name\_filter | AWS EC2 AMI search filter | `string` | `"ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"` | no |
| ami\_owner | AWS EC2 AMI owner | `string` | `"099720109477"` | no |
| backup\_link | Link from which you could download latest avilible snapshot of EWF Blockchain Data | `string` | `"https://drive.google.com/uc?id=1MSrU6Wt9-IKio4Ifj4K08bmnVk7M2VWh"` | no |
| cidr\_mask\_ingress\_ssh | IP mask in CIDR notation for SSH access - e.g. /24 or /32 | `string` | n/a | yes |
| ec2\_instance\_type | AWS EC2 instance size | `string` | `"t2.micro"` | no |
| ec2\_root\_volume\_size | AWS EC2 root volume size - in GB | `number` | `30` | no |
| environment\_name | Type of network you want to set up your node in (test/prod) | `string` | `"test"` | no |
| internet\_gw | Internet Gateway Object needed for EC2 dependency | `any` | n/a | yes |
| ip\_access\_range\_ingress\_ssh | IP range which should have SSH access to that instance e.g. 88.55.22.219 | `string` | n/a | yes |
| key\_pair\_name | Name of the key pair to attach to EC2 | `any` | n/a | yes |
| load\_backup | Variable defining whether load or not backup script | `bool` | `true` | no |
| name | Your prefix to be added to resources names | `string` | `"ewf"` | no |
| subnet\_id | Subnet ID you want to use already existing one | `string` | n/a | yes |
| vpc\_id | VPC id you want to use already existing one | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ewf\_rpc\_ec2\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

