#!/usr/bin/env bash

export AWS_REGION="us-east-1"

readonly AMI_NAME="shopback-linux-*"

set -eoux pipefail

aws ec2 describe-images \
  --filters "Name=name,Values=${AMI_NAME}" \
  --output json

# If packer doesn't have cleanup functions
# This script will do cleanup resources
# - AMIs
# - EC2 instances
