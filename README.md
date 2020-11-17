## Description
Terraform Module to quickly create EWF RPC Node on AWS.

This module:

  - Sets up Ubuntu 18.04 EC2 instance
  - Configures Security Groups:
    - Inbound:
      - 80 & 443 TCP from 0.0.0.0/0
      - 22 TCP from either your network ISP (default) or provided IP
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

- AWS Account and user generated with proper permissions (Internet Gateway, Security Groups, Route Tables, EC2, Elastic IP) or admin permissions for simplicity.

- Key pair generated to be associated with EC2 for debuging purposes (EC2 -> Key Pair -> Create Key Pair)

- Terraform installed on your machine (https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Examples
Sample example can be found in [example](./example) subfolder.

```hcl
module "ewf_rpc_prod" {
    source                            = "./ewf_setup_module"
    environment_name                  = "prod"
    ec2_root_volume_size              = 50
    backup_link                       = "https://drive.google.com/uc?id=1ULjWCLgnsleigrWlmrhWo7LptW-Csl0n"
    ec2_instance_type                 = "t3.medium"
    ip_access_range_ingress_ssh       = "89.64.55.0"
    cidr_mask_ingress_ssh             = "/24"
    vpc_id                            = "vpc_id"
    subnet_id                         = "subnet_id"
    load_backup                       = true
    name                              = "EWF"
}


```

## Limitations
Please be aware of your current networking setup to ensure that it is ok to create connection between internet and your subnet

## TODOs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

The following requirements are needed by this module:

- terraform (>= 0.13, < 0.14)

- aws (>= 3.5.0, < 4.0)

## Providers

The following providers are used by this module:

- aws (>= 3.5.0, < 4.0)

## Required Inputs

The following input variables are required:

### vpc\_id

Description: ID of VPC you want to use.

Type: `string`

### subnet\_id

Description: ID of Subnet you want to use.

Type: `string`

### internet\_gw

Description: Internet Gateway Object needed for EC2 dependency.


## Optional Inputs

The following input variables are optional (have default values):

### ec2\_instance\_type

Description: AWS EC2 instance size.

Type: `string`

Default: `"t2.micro"`

### ami\_name\_filter

Description: AWS EC2 AMI search filter.

Type: `string`

Default: `"ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"`

### ami\_owner

Description: AWS EC2 AMI owner.

Type: `string`

Default: `"099720109477"`

### ec2\_root\_volume\_size

Description: AWS EC2 root volume size - in GB.

Type: `number`

Default: `30`

### environment\_name

Description: Type of network you want to set up your node in (test/prod).

Type: `string`

Default: `"test"`

### backup\_link

Description: Link from which you could download latest avilible snapshot of EWF Blockchain Data.

Type: `string`

Default: `"https://drive.google.com/uc?id=1MSrU6Wt9-IKio4Ifj4K08bmnVk7M2VWh"`

### ip\_access\_range\_ingress\_ssh

Description: IP range which should have SSH access to that instance e.g. 88.55.22.219.

Type: `string`

Default: `""`

### cidr\_mask\_ingress\_ssh

Description: IP mask in CIDR notation - e.g. /24 or /32.

Type: `string`

Default: `""`

### name

Description: Your prefix to be added to resources names.

Type: `string`

Default: `"EWF"`

### load\_backup

Description: Variable defining whether load or not backup script.

Type: `bool`

Default: `true`

## Outputs

The following outputs are exported:

### ewf\_rpc\_ec2\_ip

Description: IP of newly configured RPC node


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

