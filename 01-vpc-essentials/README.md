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
  - [Status `blackhole`](#status-blackhole)
- [Network Access Control Lists (NACLs)](#network-access-control-lists-nacls)
- [Subnets](#subnets)
  - [Public and Private Subnets](#public-and-private-subnets)
- [Availability Zones](#availability-zones)
  - [Failover](#failover)
  - [High Availability](#high-availability)
  - [Fault Tolerance](#fault-tolerance)
- [Security Groups](#security-groups)
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
1. A **Main Route Table** with predefined routes to the default subnets.
1. A **Default Network Access Control List** with predefined rules for controlling access of the default subnets.
1. **Subnets** to provision AWS resources in (e.g. **EC2 Instances**, **RDS Instances**,...).

<br/>
<div align="center"><img src="assets/vpc-default.png" width="900"></div>
<br/>
<div align="center"><img src="assets/vpc-dashboard.png" width="650"></div>


## Internet Gateways (IGWs)

- Only **one** IGW can be `attached` to a VPC at a time.
- An IGW cannot be `detached` from a VPC while there are active AWS resources associated with **Public IP** addresses or **Elastic IP** addresses.

### State `attached`

<div align="center"><img src="assets/igw-attached.png" width="900"></div>

### State `detached`

<div align="center"><img src="assets/igw-detached.png" width="900"></div>

<div align="center"><img src="assets/igw-detached-diagram.png" width="500"></div>


## Route Tables (RTs)

- A RT contains a **set of rules**, called **routes**, that are used to **determine where network traffic is directed**. 

<br/>
<div align="center">
  <img src="assets/rt-main.png" width="850">
  <br/>
  <em>Main Route Table</em>
</div>
<br/>

- Unlike an IGW, you can have multiple active RTs in a VPC.
- You can associate multiple subnets in an RT, but one subnet cannot be associated with multiple RTs.
- Subnets that are not explicitly associated with any RTs will be implicitly associated with the **Main RT**.
- You cannot delete an RT if it has dependencies (associated subnets).

<br/>
<div align="center"><img src="assets/rt-diagram.png" width="800"></div>

### Status `blackhole`

<div align="center"><img src="assets/rt-blackhole-diagram.png" width="600"></div>
<br/>
<div align="center"><img src="assets/rt-blackhole.png" width="900"></div>


## Network Access Control Lists (NACLs)

- An NACL is an **optional layer of security** for your VPC that acts as a **firewall** for controlling traffic to flow in and out of the **subnets** with which it is associated.

<div align="center"><img src="assets/nacl-diagram.png" width="650"></div>
<br/>

- Rules are evaluated based on **`Rule #`** (a.k.a. rule number) from lowest to highest.
- The first rule that matches to the traffic gets immediately applied and executed, regardless of any rules that come after (have a higher **`Rule #`**).

<br/>
<div align="center">
  <img src="assets/nacl-default.png" width="850">
  <br/>
  <em>Default Network ACL</em>
</div>
<br/>

- Any new NACLs you create **DENY** all traffic by default.
- A subnet can only be associated with **one** NACL at a time.
- An NACL allows or denies traffic from entering a subnet. Once inside the subnet, other AWS resources (e.g. **EC2 Instances**) may have an additional layer of security, **Security Groups**.


## Subnets

> A subnet (shorthand for subnetwork) is a subsection of a network.

<div align="center">
  <img src="assets/subnet-default.png" width="900">
  <br/>
  <em>Default Subnets</em>
</div>
<br/>

1. When you create a VPC, they span all of the Availability Zones in the region.
1. After the creation, **you can add one or more subnets in each Availability Zone**.
1. Each subnet **must reside entirely** within **one** Availability Zone and **cannot span zones**.

### Public and Private Subnets

<div align="center"><img src="assets/subnet-public-private.png" width="650"></div>
<br/>

<br/>
<div align="center">
  <img src="assets/subnet-public.png" width="900">
  <br/>
  <em>Public Subnet</em>
</div>

<br/>
<div align="center">
  <img src="assets/subnet-private.png" width="900">
  <br/>
  <em>Private Subnet</em>
</div>


## Availability Zones

> AZs are distinct locations that are engineered to be isolated from failures in other AZs.

<br/>
<div align="center">
  <img src="assets/az-ordinary.png" width="500">
  <br/>
  <em>By launching instances in separate AZs</em>
</div>
<br/>

<div align="center">
  <img src="assets/az-disaster.png" width="500">
  <br/>
  <em>You can protect your applications from the failure of a single location</em>
</div>
<br/>

### Failover

> Failover is a backup operational mode in which the functions of a system component are assumed by secondary system components when the primary component becomes unavailable through either failure or scheduled downtime.

### High Availability

> A high availability system is one that is designed to be available 99.999% of the time, or as close to it as possible.

- In practice, this means creating and managing the ability to automatically failover to a secondary system if the primary system goes down for any reason as well as eliminating all single points of failure from your infrastructure.

### Fault Tolerance

> A fault-tolerant system is extremely similar to HA, but goes one step further by guaranteeing zero downtime.

- The concept of having backup components in place is called **redundancy**.
- The more backup components you have in place, the more tolerant your network is hardware and software failure.


## Security Groups

// What do Egress and Ingress mean in the cloud?
// https://www.aviatrix.com/learning/cloud-security-operations/egress-and-ingress/


## References

- [AWS Essentials](https://www.youtube.com/playlist?list=PLv2a_5pNAko0Mijc6mnv04xeOut443Wnk)
- [Project Omega - VPC](https://www.lucidchart.com/documents/view/703f6119-4838-4bbb-bc7e-be2fb75e89e5/XT05XlW_ahiW)
- [VPC Dashboard - EU (London) Region](https://eu-west-2.console.aws.amazon.com/vpc/home?region=eu-west-2)
