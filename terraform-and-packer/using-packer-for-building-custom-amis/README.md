# Using Packer for building Custom AMIs

<div align="center">
  <img src="assets/packer-terraform-aws.png" width="900">
  <br />
  <div>An example of using <b>Packer</b> in an automated workflow</div>
</div>

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [What is a Golden Image](#what-is-a-golden-image)
  - [Tips for Getting Started](#tips-for-getting-started)
- [What is Packer](#what-is-packer)
- [Templates](#templates)
  - [Template Builders](#template-builders)
  - [Template Communicators](#template-communicators)
  - [Template Engine](#template-engine)
  - [Template Post-Processors](#template-post-processors)
  - [Template Provisioners](#template-provisioners)
  - [Template User Variables](#template-user-variables)
- [Builders](#builders)
  - [AMI Builder (EBS backed)](#ami-builder-ebs-backed)
- [Provisioners](#provisioners)
- [HCL Configuration Language](#hcl-configuration-language)
- [Bonus: Cleanup](#bonus-cleanup)
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

<div align="center">
  <img src="assets/golden-image-pipeline.png" width="900">
  <br />
  <strong>Golden Image Pipeline</strong>
  <br />
</div>

<br />

<div align="center">
  <img src="assets/golden-image-value-stream-possibilities.png" width="900">
  <br />
  <strong>Golden Image Value Stream Possibilities</strong>
  <br />
</div>

### Tips for Getting Started

- Goal is to have as few Golden Images as possible to be used in all Infrastructure Scenarios.

- Include all software and configurations in the Golden Image, OR.
- Install software and do the configuration
  after the golden image has been spun up and is used by a Virtual Machine.

- Do not build images containing secrets like API Keys and Passwords.

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

### [AMI Builder (EBS backed)](https://www.packer.io/docs/builders/amazon-ebs)

Type: `amazon-ebs`

The amazon-ebs Packer builder is able to create Amazon AMIs backed by EBS volumes for use in EC2.
For more information on the difference between EBS-backed instances and instance-store backed instances,
see the "storage for the root device" section in the EC2 documentation.

This builder builds an AMI by launching an EC2 instance from a source AMI,
provisioning that running machine, and then creating an AMI from that machine.
This is all done in your own AWS account.
The builder will create temporary keypairs, security group rules, etc.
that provide it temporary access to the instance while the image is being created.
This simplifies configuration quite a bit.

The builder does not manage AMIs.
Once it creates an AMI and stores it in your account,
it is up to you to use, delete, etc. the AMI.

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/example-builders.json) -->
<!-- The below code snippet is automatically added from labs/example-builders.json -->

```json
{
  "variables": {
    "aws_region": "us-east-2"
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
==> amazon-linux-ami: Prevalidating AMI Name: shopback-learning-packer-2020-05-24T09-12-39Z
    amazon-linux-ami: Found Image ID: ami-083ebc5a49573896a
==> amazon-linux-ami: Creating temporary keypair: packer_5eca3a87-e093-5d6b-7cf9-e1d7ab8a1b86
==> amazon-linux-ami: Creating temporary security group for this instance: packer_5eca3a8d-0d76-21c9-a819-da286e5e1530
==> amazon-linux-ami: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-linux-ami: Launching a source AWS instance...
==> amazon-linux-ami: Adding tags to source instance
    amazon-linux-ami: Adding tag: "Name": "Packer Builder"
    amazon-linux-ami: Instance ID: i-0f68e7d1e817d8cba
==> amazon-linux-ami: Waiting for instance (i-0f68e7d1e817d8cba) to become ready...
==> amazon-linux-ami: Using ssh communicator to connect: 3.135.210.132
==> amazon-linux-ami: Waiting for SSH to become available...
==> amazon-linux-ami: Connected to SSH!
==> amazon-linux-ami: Stopping the source instance...
    amazon-linux-ami: Stopping instance
==> amazon-linux-ami: Waiting for the instance to stop...
==> amazon-linux-ami: Creating AMI shopback-learning-packer-2020-05-24T09-12-39Z from instance i-0f68e7d1e817d8cba
    amazon-linux-ami: AMI: ami-0f50843abd3b56267
==> amazon-linux-ami: Waiting for AMI to become ready...
==> amazon-linux-ami: Modifying attributes on AMI (ami-0f50843abd3b56267)...
    amazon-linux-ami: Modifying: description
==> amazon-linux-ami: Modifying attributes on snapshot (snap-04e1ecb3e3c5b995e)...
==> amazon-linux-ami: Terminating the source AWS instance...
==> amazon-linux-ami: Cleaning up any extra volumes...
==> amazon-linux-ami: No volumes to clean up, skipping
==> amazon-linux-ami: Deleting temporary security group...
==> amazon-linux-ami: Deleting temporary keypair...
Build 'amazon-linux-ami' finished.

==> Builds finished. The artifacts of successful builds are:
--> amazon-linux-ami: AMIs were created:
us-east-2: ami-0f50843abd3b56267
```

<!-- AUTO-GENERATED-CONTENT:END -->

<div align="center"><img src="assets/example-builders-source-ami.png" width="900"></div>
<br />

<div align="center"><img src="assets/example-builders-instance-pending.png" width="900"></div>
<br />

<div align="center"><img src="assets/example-builders-ami-pending.png" width="900"></div>
<br />

<div align="center"><img src="assets/example-builders-ami-available.png" width="900"></div>
<br />

<div align="center"><img src="assets/example-builders-snapshot-completed.png" width="900"></div>
<br />

<div align="center"><img src="assets/example-builders-instance-terminated.png" width="900"></div>
<br />

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
    "aws_region": "us-east-2"
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
      "source": "clone-source-code.sh",
      "destination": "/opt/packer/clone-source-code.sh"
    },
    {
      "type": "shell",
      "inline": ["/opt/packer/clone-source-code.sh"]
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
==> amazon-linux-ami: Prevalidating AMI Name: shopback-learning-packer-2020-05-23T04-41-57Z
    amazon-linux-ami: Found Image ID: ami-01d025118d8e760db
==> amazon-linux-ami: Creating temporary keypair: packer_5ec8a996-9295-e663-e3eb-3621e4f77c40
==> amazon-linux-ami: Creating temporary security group for this instance: packer_5ec8a99c-4998-37f1-3fbe-4f434e847cc1
==> amazon-linux-ami: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-linux-ami: Launching a source AWS instance...
==> amazon-linux-ami: Adding tags to source instance
    amazon-linux-ami: Adding tag: "Name": "Packer Builder"
    amazon-linux-ami: Instance ID: i-0bf861f30a3fa426c
==> amazon-linux-ami: Waiting for instance (i-0bf861f30a3fa426c) to become ready...
==> amazon-linux-ami: Using ssh communicator to connect: 34.205.65.203
==> amazon-linux-ami: Waiting for SSH to become available...
==> amazon-linux-ami: Connected to SSH!
==> amazon-linux-ami: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell373575102
==> amazon-linux-ami: Uploading clone-source-code.sh => /opt/packer/clone-source-code.sh

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [=============================================] 100.00% 1s
==> amazon-linux-ami: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell254046462
==> amazon-linux-ami: + sudo yum --quiet --assumeyes install git
==> amazon-linux-ami: + git clone https://github.com/A5hleyRich/wordpress-nginx.git /opt/packer/wordpress-nginx
==> amazon-linux-ami: Cloning into '/opt/packer/wordpress-nginx'...
==> amazon-linux-ami: Stopping the source instance...
    amazon-linux-ami: Stopping instance
==> amazon-linux-ami: Waiting for the instance to stop...
==> amazon-linux-ami: Creating AMI shopback-learning-packer-2020-05-23T04-41-57Z from instance i-0bf861f30a3fa426c
    amazon-linux-ami: AMI: ami-0c0f8339a416eea03
==> amazon-linux-ami: Waiting for AMI to become ready...
==> amazon-linux-ami: Modifying attributes on AMI (ami-0c0f8339a416eea03)...
    amazon-linux-ami: Modifying: description
==> amazon-linux-ami: Modifying attributes on snapshot (snap-067ba06cc3e0aa8fd)...
==> amazon-linux-ami: Terminating the source AWS instance...
==> amazon-linux-ami: Cleaning up any extra volumes...
==> amazon-linux-ami: No volumes to clean up, skipping
==> amazon-linux-ami: Deleting temporary security group...
==> amazon-linux-ami: Deleting temporary keypair...
Build 'amazon-linux-ami' finished.

==> Builds finished. The artifacts of successful builds are:
--> amazon-linux-ami: AMIs were created:
us-east-2: ami-0c0f8339a416eea03
```

<!-- AUTO-GENERATED-CONTENT:END -->

## HCL Configuration Language

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/wordpress-nginx/variables.pkr.hcl) -->
<!-- The below code snippet is automatically added from labs/wordpress-nginx/variables.pkr.hcl -->

```hcl
# variables.pkr.hcl

variable "aws_region" {
  type    = string
  default = "us-east-2"
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/wordpress-nginx/build.pkr.hcl) -->
<!-- The below code snippet is automatically added from labs/wordpress-nginx/build.pkr.hcl -->

```hcl
# build.pkr.hcl

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
    source      = "clone-source-code.sh"
    destination = "/opt/packer/clone-source-code.sh"
  }

  provisioner "shell" {
    inline = [
      "/opt/packer/clone-source-code.sh"
    ]
  }
}
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/wordpress-nginx/sources.pkr.hcl) -->
<!-- The below code snippet is automatically added from labs/wordpress-nginx/sources.pkr.hcl -->

```hcl
# sources.pkr.hcl

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
==> amazon-ebs: Prevalidating AMI Name: shopback-learning-packer-2020-05-23T04-45-18Z
    amazon-ebs: Found Image ID: ami-01d025118d8e760db
==> amazon-ebs: Creating temporary keypair: packer_5ec8aa5e-1388-cd17-569b-20e9f12b1fc6
==> amazon-ebs: Creating temporary security group for this instance: packer_5ec8aa66-0c85-4f3d-1fe6-d7eee67739d8
==> amazon-ebs: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs: Launching a source AWS instance...
==> amazon-ebs: Adding tags to source instance
    amazon-ebs: Adding tag: "Name": "Packer Builder"
    amazon-ebs: Instance ID: i-0aefdff77cc6fe562
==> amazon-ebs: Waiting for instance (i-0aefdff77cc6fe562) to become ready...
==> amazon-ebs: Using ssh communicator to connect: 35.175.130.53
==> amazon-ebs: Waiting for SSH to become available...
==> amazon-ebs: Connected to SSH!
==> amazon-ebs: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell060501310
==> amazon-ebs: Uploading clone-source-code.sh => /opt/packer/clone-source-code.sh

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [================================================] 100.00%

clone-source-code.sh 170 B / 170 B [=============================================] 100.00% 1s
==> amazon-ebs: Provisioning with shell script: /var/folders/s9/lyjc62f13fq772dt_gjt2w100000gn/T/packer-shell241211926
==> amazon-ebs: + sudo yum --quiet --assumeyes install git
==> amazon-ebs: + git clone https://github.com/A5hleyRich/wordpress-nginx.git /opt/packer/wordpress-nginx
==> amazon-ebs: Cloning into '/opt/packer/wordpress-nginx'...
==> amazon-ebs: Stopping the source instance...
    amazon-ebs: Stopping instance
==> amazon-ebs: Waiting for the instance to stop...
==> amazon-ebs: Creating AMI shopback-learning-packer-2020-05-23T04-45-18Z from instance i-0aefdff77cc6fe562
    amazon-ebs: AMI: ami-026d8f7eda024b8ed
==> amazon-ebs: Waiting for AMI to become ready...
==> amazon-ebs: Modifying attributes on AMI (ami-026d8f7eda024b8ed)...
    amazon-ebs: Modifying: description
==> amazon-ebs: Modifying attributes on snapshot (snap-0ff5c552b4f79e66b)...
==> amazon-ebs: Terminating the source AWS instance...
==> amazon-ebs: Cleaning up any extra volumes...
==> amazon-ebs: No volumes to clean up, skipping
==> amazon-ebs: Deleting temporary security group...
==> amazon-ebs: Deleting temporary keypair...
Build 'amazon-ebs' finished.

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
us-east-2: ami-026d8f7eda024b8ed
```

<!-- AUTO-GENERATED-CONTENT:END -->

## Bonus: Cleanup

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/cleanup.sh) -->
<!-- The below code snippet is automatically added from labs/cleanup.sh -->

```sh
#!/usr/bin/env bash

set -eou pipefail

export AWS_REGION="us-east-2"

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
```

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (CODE:src=labs/cleanup.console) -->
<!-- The below code snippet is automatically added from labs/cleanup.console -->

```console
Found A Matching AMI       : shopback-learning-packer-2020-05-23T04-45-18Z
- Deregistering This Image : ami-026d8f7eda024b8ed
- Deleting This Snapshot   : snap-0ff5c552b4f79e66b

Found A Matching AMI       : shopback-learning-packer-2020-05-23T04-38-41Z
- Deregistering This Image : ami-05ae982102ab92f0c
- Deleting This Snapshot   : snap-0141f0e5682cbb768

Found A Matching AMI       : shopback-learning-packer-2020-05-23T04-41-57Z
- Deregistering This Image : ami-0c0f8339a416eea03
- Deleting This Snapshot   : snap-067ba06cc3e0aa8fd
```

<!-- AUTO-GENERATED-CONTENT:END -->

Pricing
Resources

- EC2
- AMI
- Snapshot

## References

- [Building a Golden Image Pipeline](https://www.youtube.com/watch?v=mtEeYp28FnE)
- [Packer Terminology](https://www.packer.io/docs/terminology)
- [Introduction to Packer HCL2](https://www.packer.io/guides/hcl)
