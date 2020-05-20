# Getting Started

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Syntax](#syntax)
- [Command-line](#command-line)
- [Deploying Your First Terraform Configuration](#deploying-your-first-terraform-configuration)
- [Updating Your Configuration with More Resources](#updating-your-configuration-with-more-resources)
- [Configuring Resources After Creation](#configuring-resources-after-creation)
- [Adding a New Provider to Your Configuration](#adding-a-new-provider-to-your-configuration)
- [Using Variables in Deployments](#using-variables-in-deployments)
- [Using Modules for Common Configurations](#using-modules-for-common-configurations)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Syntax

## Command-line

## Deploying Your First Terraform Configuration

```bash
terraform
```

```bash
terraform fmt
```

```bash
terraform validate
```

```bash
terraform init
```

```bash
terraform plan
terraform plan -var-file=''
```

```bash
terraform apply
terraform apply -var-file=''
```

```bash
terraform show
```

```bash
terraform destroy
```

```bash
terraform force-unlock 3ebd64d0-6800-e83d-1fef-0867a0cef176
```

- IntelliJ IDE supports

Add the tree files here

```bash
$ tree -a -L 4 .
.
├── .terraform
│   └── plugins
│       └── darwin_amd64
│           ├── lock.json
│           └── terraform-provider-aws_v2.27.0_x4
├── main.tf
├── terraform.tfstate
├── terraform.tfstate.backup
└── terraform.tfvars
```

```bash
tree
```

```bash
aws ec2 describe-instances --instance-id=i-0f22cbff4f20e2d38 --region=eu-west-2
```

## Updating Your Configuration with More Resources

## Configuring Resources After Creation

## Adding a New Provider to Your Configuration

## Using Variables in Deployments

## Using Modules for Common Configurations

## References

- [EC2 Dashboard - EU (London) Region](https://eu-west-2.console.aws.amazon.com/ec2/v2/home?region=eu-west-2)
