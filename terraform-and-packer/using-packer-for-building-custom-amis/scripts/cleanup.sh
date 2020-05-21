#!/usr/bin/env bash

set -eoux pipefail

# If packer doesn't have cleanup functions
# This script will do cleanup resources
# - AMIs
# - EC2 instances
