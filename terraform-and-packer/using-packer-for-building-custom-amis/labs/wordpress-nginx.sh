#!/usr/bin/env bash

set -eoux pipefail

packer build -color=false wordpress-nginx
