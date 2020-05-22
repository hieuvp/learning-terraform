#!/usr/bin/env bash

set -eoux pipefail

packer build wordpress-nginx
