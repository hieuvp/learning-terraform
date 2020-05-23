#!/usr/bin/env bash

set -eoux pipefail

sudo yum --quiet --assumeyes install git
git clone https://github.com/A5hleyRich/wordpress-nginx.git /opt/packer/wordpress-nginx
