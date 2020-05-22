# Using Packer for building Custom AMI's

<div align="center"><img src="assets/packer-terraform-aws.png" width="900"></div>

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [What is a Golden Image](#what-is-a-golden-image)
- [What is Packer](#what-is-packer)
- [Templates](#templates)
  - [Template Builders](#template-builders)
  - [Template Communicators](#template-communicators)
  - [Template Engine](#template-engine)
  - [Template Post-Processors](#template-post-processors)
  - [Template Provisioners](#template-provisioners)
  - [Template User Variables](#template-user-variables)
- [Builders](#builders)
- [Provisioners](#provisioners)
- [HCL Configuration Language](#hcl-configuration-language)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## What is a Golden Image

A golden image provides the template which a virtual machine
(for example, AWS EC2 instances) is created from.
It may also be referred to as a base image or an image template.
Think of it as a snapshot copy of an operating system that can be launched as a new virtual machine.

The idea is that you set up an operating system to the desired state,
save it and then you can re-use it across your infrastructure.

In network virtualization,
a golden image is an archetypal version of a cloned disk
that can be used as a template for various kinds of virtual network hardware.
Some refer to the golden image as a master image
because multiple copies are used to provide a consistent process for using a disk image.

Using golden images as templates,
managers can create consistent environments
where the end user doesn't have to know a lot about the technology in order to use it effectively.
These kinds of systems are taking off in a big way as companies
and enterprises replace old physical networks with virtual structures.

It's a term that has made its way into the collective consciousness
of anyone involved in creating one perfect model and then producing many duplicates from that mold.
That's what a gold master, or golden image, is:
The virtual mold from which you cast your distributable models.

And in system administration,
you may encounter golden images of an organization's chosen operating system,
with the important settings baked in—the virtual private network (VPN) certificates
are already in place,
incoming email servers are already set in the email client, and so on.
Similarly, you might also hear this term in the world of virtual machines (VMs),
where a golden image of a carefully configured virtual drive
is the source from which all new virtual machines are cloned.

<div align="center"><img src="assets/tips-for-getting-started.png" width="900"></div>

<div align="center"><img src="assets/golden-image-pipeline.png" width="900"></div>

<div align="center"><img src="assets/golden-image-value-stream-possibilities.png" width="900"></div>

## What is Packer

> HashiCorp Packer has become the standard open source tool
> for creating golden images from code.

Learn how to use HashiCorp Packer in an Azure pipeline to maintain immutable infrastructure.
A battle-tested virtual machine template
that forms the foundation for all other VMs used in the infrastructure.
Sometimes they're called base images or image templates,
but the goal remains the same: immutable infrastructure.

In this session from Microsoft Ignite,
you will see how to create pipelines to host golden images in Azure,
and make them available through Azure's Shared Image Gallery.
Simply do the configuration work once, and use it across your entire infrastructure.
It will save you time, make you faster and reduce human error.

Packer is an open source tool for creating identical machine images
for multiple platforms from a single source configuration.
Packer is lightweight, runs on every major operating system, and is highly performant,
creating machine images for multiple platforms in parallel.
Packer does not replace configuration management like Chef or Puppet.
In fact, when building images,
Packer is able to use tools like Chef or Puppet to install software onto the image.

A machine image is a single static unit that contains a pre-configured operating system
and installed software which is used to quickly create new running machines.
Machine image formats change for each platform.
Some examples include AMIs for EC2, VMDK/VMX files for VMware, OVF exports for VirtualBox, etc.

## Templates

Templates are JSON files that configure the various components of Packer
in order to create one or more machine images.
Templates are portable, static, and readable and writable by both humans and computers.
This has the added benefit of being able to not only create and modify templates by hand,
but also write scripts to dynamically create or modify templates.

Templates are given to commands such as `packer build`,
which will take the template and actually run the builds within it,
producing any resulting machine images.

Templates are JSON files which define one or more builds
by configuring the various components of Packer.
Packer is able to read a template and use that information to create multiple machine images in parallel.

### Template Builders

Within the template,
the builders section contains an array of all the builders
that Packer should use to generate machine images for the template.

Builders are responsible for creating machines and generating images from them for various platforms.
For example, there are separate builders for EC2, VMware, VirtualBox, etc.
Packer comes with many builders by default,
and can also be extended to add new builders.

### Template Communicators

Communicators are the mechanism Packer uses to
upload files, execute scripts, etc. with the machine being created.

### Template Engine

All strings within templates are processed by a common Packer templating engine,
where variables and functions can be used to modify the value of a configuration parameter at runtime.

The syntax of templates uses the following conventions:

- Anything template related happens within double-braces: `{{ }}`.
- Functions are specified directly within the braces, such as `{{timestamp}}`.
- Template variables are prefixed with a period and capitalized, such as `{{.Variable}}`.

### Template Post-Processors

The post-processor section within a template configures any post-processing
that will be done to images built by the builders.
Examples of post-processing would be compressing files, uploading artifacts, etc.

Post-processors are optional.
If no post-processors are defined within a template,
then no post-processing will be done to the image.
The resulting artifact of a build is just the image outputted by the builder.

### Template Provisioners

Within the template,
the provisioners section contains an array of all the provisioners
that Packer should use to install and configure software within running machines prior
to turning them into machine images.

Provisioners are optional.
If no provisioners are defined within a template,
then no software other than the defaults will be installed within the resulting machine images.
This is not typical, however, since much of the value of Packer is
to produce multiple identical images of pre-configured software.

### Template User Variables

User variables allow your templates to be further configured
with variables from the command-line, environment variables, Vault, or files.
This lets you parameterize your templates so that
you can keep secret tokens, environment-specific data,
and other types of information out of your templates.
This maximizes the portability of the template.

Using user variables expects you to know how configuration templates work.
If you don't know how configuration templates work yet, please read that page first.

## Builders

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
      "ami_name": "training-amazon-linux-{{isotime | clean_resource_name}}",
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

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/packer-builders.sh) -->
<!-- The below code snippet is automatically added from labs/packer-builders.sh -->

```sh
#!/usr/bin/env bash

set -eoux pipefail

packer validate packer-builders.json

packer build packer-builders.json
```

<!-- AUTO-GENERATED-CONTENT:END -->

## Provisioners

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
      "ami_name": "training-amazon-linux-{{isotime | clean_resource_name}}",
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
        "sudo chown -R ec2-user:ec2-user /opt"
      ]
    },
    {
      "type": "file",
      "source": "wordpress-nginx.sh",
      "destination": "/opt/packer/wordpress-nginx.sh"
    },
    {
      "type": "shell",
      "inline": ["/opt/packer/wordpress-nginx.sh"]
    }
  ]
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/packer-provisioners.sh) -->
<!-- The below code snippet is automatically added from labs/packer-provisioners.sh -->

```sh
#!/usr/bin/env bash

set -eoux pipefail

packer validate packer-provisioners.json

packer build packer-provisioners.json
```

<!-- AUTO-GENERATED-CONTENT:END -->

## HCL Configuration Language

## References

- [Building a Golden Image Pipeline](https://www.youtube.com/watch?v=mtEeYp28FnE)
- [Packer Terminology](https://www.packer.io/docs/terminology)
- [Introduction to Packer HCL2](https://www.packer.io/guides/hcl)
