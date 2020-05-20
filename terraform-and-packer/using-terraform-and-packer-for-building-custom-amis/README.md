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

## Packer - Provisioners

> Provisioners are components of Packer that install and configure software
> within a running machine prior to that machine being turned into a static image.
> They perform the major work of making the image contain useful software.
> Example provisioners include shell scripts, Chef, Puppet, etc.

## References

- [Packer Terminology](https://www.packer.io/docs/terminology)
