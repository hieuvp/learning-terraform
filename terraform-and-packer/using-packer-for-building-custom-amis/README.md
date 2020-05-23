# Using Packer for building Custom AMI's

<div align="center">
  <img src="assets/packer-terraform-aws.png" width="900">
</div>

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
- [Cleanup](#cleanup)
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

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/example-builders.json) -->
<!-- The below code snippet is automatically added from labs/example-builders.json -->

```json
{
  "variables": {
    "aws_region": "us-east-1"
  },
  "builders": [
    {
      "ami_name": "shopback-learning-packer-{{isotime | clean_resource_name}}",
      "ami_description": "ShopBack Linux AMI",
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

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/example-builders.console) -->
<!-- The below code snippet is automatically added from labs/example-builders.console -->

```console
+ packer validate example-builders.json
Template validated successfully.
+ packer build -color=false example-builders.json
==> amazon-linux-ami: Prevalidating any provided VPC information
==> amazon-linux-ami: Prevalidating AMI Name: shopback-learning-packer-2020-05-23T03-46-52Z
    amazon-linux-ami: Found Image ID: ami-01d025118d8e760db
==> amazon-linux-ami: Creating temporary keypair: packer_5ec89cac-aefb-67d4-78bc-6c834e5916a3
==> amazon-linux-ami: Creating temporary security group for this instance: packer_5ec89cb4-52ca-84b7-8532-5d6182461087
==> amazon-linux-ami: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-linux-ami: Launching a source AWS instance...
==> amazon-linux-ami: Adding tags to source instance
    amazon-linux-ami: Adding tag: "Name": "Packer Builder"
    amazon-linux-ami: Instance ID: i-0766343d4f36842c6
==> amazon-linux-ami: Waiting for instance (i-0766343d4f36842c6) to become ready...
==> amazon-linux-ami: Using ssh communicator to connect: 100.25.45.201
==> amazon-linux-ami: Waiting for SSH to become available...
==> amazon-linux-ami: Connected to SSH!
==> amazon-linux-ami: Stopping the source instance...
    amazon-linux-ami: Stopping instance
==> amazon-linux-ami: Waiting for the instance to stop...
==> amazon-linux-ami: Creating AMI shopback-learning-packer-2020-05-23T03-46-52Z from instance i-0766343d4f36842c6
    amazon-linux-ami: AMI: ami-0a85e167a599cf2ad
==> amazon-linux-ami: Waiting for AMI to become ready...
==> amazon-linux-ami: Modifying attributes on AMI (ami-0a85e167a599cf2ad)...
    amazon-linux-ami: Modifying: description
==> amazon-linux-ami: Modifying attributes on snapshot (snap-03d20465b34eb0ab8)...
==> amazon-linux-ami: Terminating the source AWS instance...
==> amazon-linux-ami: Cleaning up any extra volumes...
==> amazon-linux-ami: No volumes to clean up, skipping
==> amazon-linux-ami: Deleting temporary security group...
==> amazon-linux-ami: Deleting temporary keypair...
Build 'amazon-linux-ami' finished.

==> Builds finished. The artifacts of successful builds are:
--> amazon-linux-ami: AMIs were created:
us-east-1: ami-0a85e167a599cf2ad
```

<!-- AUTO-GENERATED-CONTENT:END -->

## Provisioners

> Provisioners are components of Packer that install and configure software
> within a running machine prior to that machine being turned into a static image.
> They perform the major work of making the image contain useful software.
> Example provisioners include shell scripts, Chef, Puppet, etc.

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/example-provisioners.json) -->
<!-- The below code snippet is automatically added from labs/example-provisioners.json -->

```json
{
  "variables": {
    "aws_region": "us-east-1"
  },
  "builders": [
    {
      "ami_name": "shopback-learning-packer-{{isotime | clean_resource_name}}",
      "ami_description": "ShopBack Linux AMI",
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
        "sudo mkdir -p /opt/packer/wordpress-nginx",
        "sudo chown -R ec2-user:ec2-user /opt"
      ]
    },
    {
      "type": "file",
      "source": "example-wordpress-nginx.sh",
      "destination": "/opt/packer/example-wordpress-nginx.sh"
    },
    {
      "type": "shell",
      "inline": ["/opt/packer/example-wordpress-nginx.sh"]
    }
  ]
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/example-provisioners.console) -->
<!-- The below code snippet is automatically added from labs/example-provisioners.console -->

```console
+ packer validate example-provisioners.json
Template validated successfully.
+ packer build -color=false example-provisioners.json
==> amazon-linux-ami: Prevalidating any provided VPC information
==> amazon-linux-ami: Prevalidating AMI Name: shopback-learning-packer-2020-05-23T03-50-13Z
    amazon-linux-ami: Found Image ID: ami-01d025118d8e760db
==> amazon-linux-ami: Creating temporary keypair: packer_5ec89d75-b0fb-de71-9bd0-ee74db4a4704
==> amazon-linux-ami: Creating temporary security group for this instance: packer_5ec89d7e-2d83-0eea-c498-35a4bf991018
==> amazon-linux-ami: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-linux-ami: Launching a source AWS instance...
==> amazon-linux-ami: Adding tags to source instance
    amazon-linux-ami: Adding tag: "Name": "Packer Builder"
    amazon-linux-ami: Instance ID: i-029275ffa33807016
==> amazon-linux-ami: Waiting for instance (i-029275ffa33807016) to become ready...
==> amazon-linux-ami: Using ssh communicator to connect: 34.232.67.26
==> amazon-linux-ami: Waiting for SSH to become available...
==> amazon-linux-ami: Connected to SSH!
==> amazon-linux-ami: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell540288373
==> amazon-linux-ami: Uploading example-wordpress-nginx.sh => /opt/packer/example-wordpress-nginx.sh

example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [=======================================] 100.00% 1s
==> amazon-linux-ami: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell326068397
==> amazon-linux-ami: + sudo yum -y install git
    amazon-linux-ami: Loaded plugins: priorities, update-motd, upgrade-helper
    amazon-linux-ami: Resolving Dependencies
    amazon-linux-ami: --> Running transaction check
    amazon-linux-ami: ---> Package git.x86_64 0:2.14.6-1.62.amzn1 will be installed
    amazon-linux-ami: --> Processing Dependency: perl-Git = 2.14.6-1.62.amzn1 for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-linux-ami: --> Processing Dependency: perl(Term::ReadKey) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-linux-ami: --> Processing Dependency: perl(Git::I18N) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-linux-ami: --> Processing Dependency: perl(Git) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-linux-ami: --> Processing Dependency: perl(Error) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-linux-ami: --> Running transaction check
    amazon-linux-ami: ---> Package perl-Error.noarch 1:0.17020-2.9.amzn1 will be installed
    amazon-linux-ami: ---> Package perl-Git.noarch 0:2.14.6-1.62.amzn1 will be installed
    amazon-linux-ami: ---> Package perl-TermReadKey.x86_64 0:2.30-20.9.amzn1 will be installed
    amazon-linux-ami: --> Finished Dependency Resolution
    amazon-linux-ami:
    amazon-linux-ami: Dependencies Resolved
    amazon-linux-ami:
    amazon-linux-ami: ================================================================================
    amazon-linux-ami:  Package              Arch       Version                 Repository        Size
    amazon-linux-ami: ================================================================================
    amazon-linux-ami: Installing:
    amazon-linux-ami:  git                  x86_64     2.14.6-1.62.amzn1       amzn-updates      12 M
    amazon-linux-ami: Installing for dependencies:
    amazon-linux-ami:  perl-Error           noarch     1:0.17020-2.9.amzn1     amzn-main         33 k
    amazon-linux-ami:  perl-Git             noarch     2.14.6-1.62.amzn1       amzn-updates      69 k
    amazon-linux-ami:  perl-TermReadKey     x86_64     2.30-20.9.amzn1         amzn-main         33 k
    amazon-linux-ami:
    amazon-linux-ami: Transaction Summary
    amazon-linux-ami: ================================================================================
    amazon-linux-ami: Install  1 Package (+3 Dependent packages)
    amazon-linux-ami:
    amazon-linux-ami: Total download size: 12 M
    amazon-linux-ami: Installed size: 29 M
    amazon-linux-ami: Downloading packages:
    amazon-linux-ami: --------------------------------------------------------------------------------
    amazon-linux-ami: Total                                              7.8 MB/s |  12 MB  00:01
    amazon-linux-ami: Running transaction check
    amazon-linux-ami: Running transaction test
    amazon-linux-ami: Transaction test succeeded
    amazon-linux-ami: Running transaction
    amazon-linux-ami:   Installing : 1:perl-Error-0.17020-2.9.amzn1.noarch                        1/4
    amazon-linux-ami:   Installing : perl-TermReadKey-2.30-20.9.amzn1.x86_64                      2/4
    amazon-linux-ami:   Installing : git-2.14.6-1.62.amzn1.x86_64                                 3/4
    amazon-linux-ami:   Installing : perl-Git-2.14.6-1.62.amzn1.noarch                            4/4
    amazon-linux-ami:   Verifying  : 1:perl-Error-0.17020-2.9.amzn1.noarch                        1/4
    amazon-linux-ami:   Verifying  : git-2.14.6-1.62.amzn1.x86_64                                 2/4
    amazon-linux-ami:   Verifying  : perl-Git-2.14.6-1.62.amzn1.noarch                            3/4
    amazon-linux-ami:   Verifying  : perl-TermReadKey-2.30-20.9.amzn1.x86_64                      4/4
    amazon-linux-ami:
    amazon-linux-ami: Installed:
    amazon-linux-ami:   git.x86_64 0:2.14.6-1.62.amzn1
    amazon-linux-ami:
    amazon-linux-ami: Dependency Installed:
    amazon-linux-ami:   perl-Error.noarch 1:0.17020-2.9.amzn1     perl-Git.noarch 0:2.14.6-1.62.amzn1
    amazon-linux-ami:   perl-TermReadKey.x86_64 0:2.30-20.9.amzn1
    amazon-linux-ami:
    amazon-linux-ami: Complete!
==> amazon-linux-ami: + git clone https://github.com/A5hleyRich/wordpress-nginx.git /opt/packer/wordpress-nginx
==> amazon-linux-ami: Cloning into '/opt/packer/wordpress-nginx'...
==> amazon-linux-ami: Stopping the source instance...
    amazon-linux-ami: Stopping instance
==> amazon-linux-ami: Waiting for the instance to stop...
==> amazon-linux-ami: Creating AMI shopback-learning-packer-2020-05-23T03-50-13Z from instance i-029275ffa33807016
    amazon-linux-ami: AMI: ami-0629c41cdf589b976
==> amazon-linux-ami: Waiting for AMI to become ready...
==> amazon-linux-ami: Modifying attributes on AMI (ami-0629c41cdf589b976)...
    amazon-linux-ami: Modifying: description
==> amazon-linux-ami: Modifying attributes on snapshot (snap-09c24f29b6f19982b)...
==> amazon-linux-ami: Terminating the source AWS instance...
==> amazon-linux-ami: Cleaning up any extra volumes...
==> amazon-linux-ami: No volumes to clean up, skipping
==> amazon-linux-ami: Deleting temporary security group...
==> amazon-linux-ami: Deleting temporary keypair...
Build 'amazon-linux-ami' finished.

==> Builds finished. The artifacts of successful builds are:
--> amazon-linux-ami: AMIs were created:
us-east-1: ami-0629c41cdf589b976
```

<!-- AUTO-GENERATED-CONTENT:END -->

## HCL Configuration Language

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/wordpress-nginx/variables.pkr.hcl) -->
<!-- The below code snippet is automatically added from labs/wordpress-nginx/variables.pkr.hcl -->

```hcl
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/wordpress-nginx/build.pkr.hcl) -->
<!-- The below code snippet is automatically added from labs/wordpress-nginx/build.pkr.hcl -->

```hcl
build {
  sources = [
    "source.amazon-ebs.example"
  ]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/packer/wordpress-nginx",
      "sudo chown -R ec2-user:ec2-user /opt"
    ]
  }

  provisioner "file" {
    source      = "example-wordpress-nginx.sh"
    destination = "/opt/packer/example-wordpress-nginx.sh"
  }

  provisioner "shell" {
    inline = [
      "/opt/packer/example-wordpress-nginx.sh"
    ]
  }
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/wordpress-nginx/sources.pkr.hcl) -->
<!-- The below code snippet is automatically added from labs/wordpress-nginx/sources.pkr.hcl -->

```hcl
source "amazon-ebs" "example" {
  # name = "amazon-linux-ami"?

  ami_name        = "shopback-learning-packer-{{isotime | clean_resource_name}}"
  ami_description = "ShopBack Linux AMI"
  instance_type   = "t2.micro"
  region          = var.aws_region
  ssh_username    = "ec2-user"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      architecture        = "x86_64"
      name                = "*amzn-ami-hvm-*"
      root-device-type    = "ebs"

      # "block-device-mapping.volume-type" = "gp2"?

    }
    owners      = ["amazon"]
    most_recent = true
  }
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/wordpress-nginx.console) -->
<!-- The below code snippet is automatically added from labs/wordpress-nginx.console -->

```console
+ packer build -color=false wordpress-nginx
==> amazon-ebs: Prevalidating any provided VPC information
==> amazon-ebs: Prevalidating AMI Name: shopback-learning-packer-2020-05-23T03-53-42Z
    amazon-ebs: Found Image ID: ami-01d025118d8e760db
==> amazon-ebs: Creating temporary keypair: packer_5ec89e46-acf5-7b55-719f-6ddf35cfaadc
==> amazon-ebs: Creating temporary security group for this instance: packer_5ec89e4d-e60d-66ad-d856-4b846b56ce8f
==> amazon-ebs: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs: Launching a source AWS instance...
==> amazon-ebs: Adding tags to source instance
    amazon-ebs: Adding tag: "Name": "Packer Builder"
    amazon-ebs: Instance ID: i-0eab66a5c24854d98
==> amazon-ebs: Waiting for instance (i-0eab66a5c24854d98) to become ready...
==> amazon-ebs: Using ssh communicator to connect: 54.164.93.97
==> amazon-ebs: Waiting for SSH to become available...
==> amazon-ebs: Connected to SSH!
==> amazon-ebs: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell425991605
==> amazon-ebs: Uploading example-wordpress-nginx.sh => /opt/packer/example-wordpress-nginx.sh

example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [==========================================] 100.00%
[1A
example-wordpress-nginx.sh 153 B / 153 B [=======================================] 100.00% 1s
==> amazon-ebs: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell962109293
==> amazon-ebs: + sudo yum -y install git
    amazon-ebs: Loaded plugins: priorities, update-motd, upgrade-helper
    amazon-ebs: Resolving Dependencies
    amazon-ebs: --> Running transaction check
    amazon-ebs: ---> Package git.x86_64 0:2.14.6-1.62.amzn1 will be installed
    amazon-ebs: --> Processing Dependency: perl-Git = 2.14.6-1.62.amzn1 for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-ebs: --> Processing Dependency: perl(Term::ReadKey) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-ebs: --> Processing Dependency: perl(Git::I18N) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-ebs: --> Processing Dependency: perl(Git) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-ebs: --> Processing Dependency: perl(Error) for package: git-2.14.6-1.62.amzn1.x86_64
    amazon-ebs: --> Running transaction check
    amazon-ebs: ---> Package perl-Error.noarch 1:0.17020-2.9.amzn1 will be installed
    amazon-ebs: ---> Package perl-Git.noarch 0:2.14.6-1.62.amzn1 will be installed
    amazon-ebs: ---> Package perl-TermReadKey.x86_64 0:2.30-20.9.amzn1 will be installed
    amazon-ebs: --> Finished Dependency Resolution
    amazon-ebs:
    amazon-ebs: Dependencies Resolved
    amazon-ebs:
    amazon-ebs: ================================================================================
    amazon-ebs:  Package              Arch       Version                 Repository        Size
    amazon-ebs: ================================================================================
    amazon-ebs: Installing:
    amazon-ebs:  git                  x86_64     2.14.6-1.62.amzn1       amzn-updates      12 M
    amazon-ebs: Installing for dependencies:
    amazon-ebs:  perl-Error           noarch     1:0.17020-2.9.amzn1     amzn-main         33 k
    amazon-ebs:  perl-Git             noarch     2.14.6-1.62.amzn1       amzn-updates      69 k
    amazon-ebs:  perl-TermReadKey     x86_64     2.30-20.9.amzn1         amzn-main         33 k
    amazon-ebs:
    amazon-ebs: Transaction Summary
    amazon-ebs: ================================================================================
    amazon-ebs: Install  1 Package (+3 Dependent packages)
    amazon-ebs:
    amazon-ebs: Total download size: 12 M
    amazon-ebs: Installed size: 29 M
    amazon-ebs: Downloading packages:
    amazon-ebs: --------------------------------------------------------------------------------
    amazon-ebs: Total                                              7.0 MB/s |  12 MB  00:01
    amazon-ebs: Running transaction check
    amazon-ebs: Running transaction test
    amazon-ebs: Transaction test succeeded
    amazon-ebs: Running transaction
    amazon-ebs:   Installing : 1:perl-Error-0.17020-2.9.amzn1.noarch                        1/4
    amazon-ebs:   Installing : perl-TermReadKey-2.30-20.9.amzn1.x86_64                      2/4
    amazon-ebs:   Installing : git-2.14.6-1.62.amzn1.x86_64                                 3/4
    amazon-ebs:   Installing : perl-Git-2.14.6-1.62.amzn1.noarch                            4/4
    amazon-ebs:   Verifying  : 1:perl-Error-0.17020-2.9.amzn1.noarch                        1/4
    amazon-ebs:   Verifying  : git-2.14.6-1.62.amzn1.x86_64                                 2/4
    amazon-ebs:   Verifying  : perl-Git-2.14.6-1.62.amzn1.noarch                            3/4
    amazon-ebs:   Verifying  : perl-TermReadKey-2.30-20.9.amzn1.x86_64                      4/4
    amazon-ebs:
    amazon-ebs: Installed:
    amazon-ebs:   git.x86_64 0:2.14.6-1.62.amzn1
    amazon-ebs:
    amazon-ebs: Dependency Installed:
    amazon-ebs:   perl-Error.noarch 1:0.17020-2.9.amzn1     perl-Git.noarch 0:2.14.6-1.62.amzn1
    amazon-ebs:   perl-TermReadKey.x86_64 0:2.30-20.9.amzn1
    amazon-ebs:
    amazon-ebs: Complete!
==> amazon-ebs: + git clone https://github.com/A5hleyRich/wordpress-nginx.git /opt/packer/wordpress-nginx
==> amazon-ebs: Cloning into '/opt/packer/wordpress-nginx'...
==> amazon-ebs: Stopping the source instance...
    amazon-ebs: Stopping instance
==> amazon-ebs: Waiting for the instance to stop...
==> amazon-ebs: Creating AMI shopback-learning-packer-2020-05-23T03-53-42Z from instance i-0eab66a5c24854d98
    amazon-ebs: AMI: ami-0a472499cdca02d58
==> amazon-ebs: Waiting for AMI to become ready...
==> amazon-ebs: Modifying attributes on AMI (ami-0a472499cdca02d58)...
    amazon-ebs: Modifying: description
==> amazon-ebs: Modifying attributes on snapshot (snap-0a8742c52666b82a9)...
==> amazon-ebs: Terminating the source AWS instance...
==> amazon-ebs: Cleaning up any extra volumes...
==> amazon-ebs: No volumes to clean up, skipping
==> amazon-ebs: Deleting temporary security group...
==> amazon-ebs: Deleting temporary keypair...
Build 'amazon-ebs' finished.

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-1: ami-0a472499cdca02d58
```

<!-- AUTO-GENERATED-CONTENT:END -->

## Cleanup

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/cleanup.sh) -->
<!-- The below code snippet is automatically added from labs/cleanup.sh -->

```sh
#!/usr/bin/env bash

set -eou pipefail

export AWS_REGION="us-east-1"

readonly AMI_NAME="shopback-learning-packer-*"
readonly IMAGES=$(
  aws ec2 describe-images --output json \
    --filters "Name=name,Values=${AMI_NAME}"
)

main() {
  local -r index=$1
  local -r name=$(echo "$IMAGES" | jq --raw-output ".Images[${index}].Name")
  local -r image_id=$(echo "$IMAGES" | jq --raw-output ".Images[${index}].ImageId")
  local -r snapshot_id=$(echo "$IMAGES" | jq --raw-output ".Images[${index}].BlockDeviceMappings[0].Ebs.SnapshotId")

  printf "\n"
  echo "Found A Matching AMI       : ${name}"

  echo "- Deregistering This Image : ${image_id}"
  aws ec2 deregister-image --image-id "$image_id"

  echo "- Deleting This Snapshot   : ${snapshot_id}"
  aws ec2 delete-snapshot --snapshot-id "$snapshot_id"
}

for index in $(echo "$IMAGES" | jq '.Images | keys | .[]'); do
  main "$index"
done

printf "\n"
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/cleanup.console) -->
<!-- The below code snippet is automatically added from labs/cleanup.console -->

```console
Found A Matching AMI       : shopback-learning-packer-2020-05-23T03-50-13Z
- Deregistering This Image : ami-0629c41cdf589b976
- Deleting This Snapshot   : snap-09c24f29b6f19982b

Found A Matching AMI       : shopback-learning-packer-2020-05-23T03-53-42Z
- Deregistering This Image : ami-0a472499cdca02d58
- Deleting This Snapshot   : snap-0a8742c52666b82a9

Found A Matching AMI       : shopback-learning-packer-2020-05-23T03-46-52Z
- Deregistering This Image : ami-0a85e167a599cf2ad
- Deleting This Snapshot   : snap-03d20465b34eb0ab8
```

<!-- AUTO-GENERATED-CONTENT:END -->

Pricing
Resources

- EC2
- AMI
- Snapshot ==> Why?

## References

- [Building a Golden Image Pipeline](https://www.youtube.com/watch?v=mtEeYp28FnE)
- [Packer Terminology](https://www.packer.io/docs/terminology)
- [Introduction to Packer HCL2](https://www.packer.io/guides/hcl)
