#!/usr/bin/env bash

set -eoux pipefail

packer validate packer-provisioners.json

packer build packer-provisioners.json
