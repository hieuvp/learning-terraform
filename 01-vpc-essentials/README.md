# VPC Essentials

<div align="center"><img src="assets/big-picture.png" width="750"></div>

## Table of Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [AWS Global Infrastructure](#aws-global-infrastructure)
- [Virtual Private Cloud (VPC)](#virtual-private-cloud-vpc)
- [Internet Gateways (IGWs)](#internet-gateways-igws)
  - [State `attached`](#state-attached)
  - [State `detached`](#state-detached)
- [Route Tables (RTs)](#route-tables-rts)
- [Network Access Control Lists (NACLs)](#network-access-control-lists-nacls)
- [Subnets](#subnets)
- [Availability Zones (VPC Specific)](#availability-zones-vpc-specific)
- [References](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## AWS Global Infrastructure

- **Regions** are comprised of multiple **Availability Zones**.
- **Availability Zones** (AZs) are where separate, physical **AWS Data Centers** are located.

<div align="center"><img src="assets/aws-region.png" width="520"></div>


## Virtual Private Cloud (VPC)

<div align="center"><img src="assets/vpc-diagram.png" width="500"></div>
<br/>

When creating an AWS account, a **Default VPC** is created for us, including the standard components that are needed make it functional:

1. An **Internet Gateway** attached.
1. A main **Route Table** with predefined routes to the default subnets.
1. A **Network Access Control List** with predefined rules for access.
1. **Subnets** to provision AWS resources in (such as **EC2 Instances**).

<div align="center"><img src="assets/vpc-default.png" width="900"></div>
<br/>
<div align="center"><img src="assets/vpc-dashboard.png" width="650"></div>


## Internet Gateways (IGWs)

- Only **one** IGW can be `attached` to a VPC at a time.
- An IGW cannot be `detached` from a VPC while there are active AWS resources in the VPC (such as an EC2 Instance or an RDS Database).

### State `attached`

<div align="center"><img src="assets/igw-attached.png" width="900"></div>

### State `detached`

<div align="center"><img src="assets/igw-detached.png" width="900"></div>

<div align="center"><img src="assets/igw-detached-diagram.png" width="500"></div>


## Route Tables (RTs)

> A route table contains a **set of rules**, called **routes**, that are used to **determine where network traffic is directed**. 

<br/>
<div align="center">
  <img src="assets/rt-main.png" width="900">
  <br/>
  <em>Main Route Table</em>
</div>

Explain each lines into the diagram
- 172.31.0.0/16 -> other two lines
- 0.0.0.0/0 -> internet line

Detach IGW example
-> Black hole

Replace by another IGW example


- Unlike an IGW, you can have multiple "active" route tables in a VPC
- You cannot delete a route table if it has "dependencies" (associated subnets)

Create another route table example
- Not deletable (why Main?)
- Deletable RT

## Network Access Control Lists (NACLs)


## Subnets


## Availability Zones (VPC Specific)


## References

- [AWS Essentials](https://www.youtube.com/playlist?list=PLv2a_5pNAko0Mijc6mnv04xeOut443Wnk)
- [Project Omega](https://www.lucidchart.com/documents/view/703f6119-4838-4bbb-bc7e-be2fb75e89e5/XT05XlW_ahiW)
