# Using Terraform and Packer for building Custom AMI's

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Packer - Builders](#packer---builders)
- [Packer - Provisioners](#packer---provisioners)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Packer - Builders

> Builders are components of Packer that are able to create a machine image for a single platform.
> Builders read in some configuration and use that to run and generate a machine image.
> A builder is invoked as part of a build in order to create the actual resulting images.
> Example builders include VirtualBox, VMware, and Amazon EC2.
> Builders can be created and added to Packer in the form of plugins.

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/packer-builders.json) -->
<!-- The below code snippet is automatically added from labs/packer-builders.json -->

```json
{
  "variables": {
    "aws_region": "us-east-1"
  },
  "builders": [
    {
      "ami_name": "training-amazon-linux-{{isotime | clean_ami_name}}",
      "ami_description": "Linux-AMI",
      "instance_type": "t2.micro",
      "name": "amazon-linux-ami",
      "region": "{{user `aws_region`}}",
      "type": "amazon-ebs",
      "source_ami_filter": {
        "filters": {
          "virtualization-type": "hvm",
          "architecture": "x86_64",
          "name": "*amzn-ami-hvm-*",
          "block-device-mapping.volume-type": "gp2",
          "root-device-type": "ebs"
        },
        "owners": ["amazon"],
        "most_recent": true
      },
      "ssh_username": "ec2-user"
    }
  ]
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

## Packer - Provisioners

> Provisioners are components of Packer that install and configure software
> within a running machine prior to that machine being turned into a static image.
> They perform the major work of making the image contain useful software.
> Example provisioners include shell scripts, Chef, Puppet, etc.

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/packer-provisioners.json) -->
<!-- The below code snippet is automatically added from labs/packer-provisioners.json -->

```json
{
  "variables": {
    "aws_region": "us-east-1"
  },
  "builders": [
    {
      "ami_name": "training-amazon-linux-{{isotime | clean_ami_name}}",
      "ami_description": "Linux-AMI",
      "instance_type": "t2.micro",
      "name": "amazon-linux-ami",
      "region": "{{user `aws_region`}}",
      "type": "amazon-ebs",
      "source_ami_filter": {
        "filters": {
          "virtualization-type": "hvm",
          "architecture": "x86_64",
          "name": "*amzn-ami-hvm-*",
          "block-device-mapping.volume-type": "gp2",
          "root-device-type": "ebs"
        },
        "owners": ["amazon"],
        "most_recent": true
      },
      "ssh_username": "ec2-user"
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "sudo mkdir -p /opt/packer",
        "sudo mkdir -p /opt/packer/nginx",
        "sudo yum install -y git",
        "sudo chown -R ec2-user:ec2-user /opt"
      ]
    },
    {
      "type": "file",
      "source": "db_client",
      "destination": "/opt/packer/"
    },
    {
      "type": "file",
      "source": "go-exec-amd64",
      "destination": "/opt/packer/"
    },
    {
      "type": "file",
      "source": "client.service",
      "destination": "/opt/packer/"
    },
    {
      "type": "shell",
      "inline": [
        "git clone https://github.com/A5hleyRich/wordpress-nginx.git /opt/packer/nginx",
        "sudo chmod a+x /opt/packer/*",
        "sudo chown -R root:root /opt/packer/go-exec-amd64"
      ]
    }
  ]
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

## References

- [Packer Terminology](https://www.packer.io/docs/terminology)
