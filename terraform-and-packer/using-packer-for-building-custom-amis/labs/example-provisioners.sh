#!/usr/bin/env bash

set -eoux pipefail

packer validate example-provisioners.json
packer build -color=false example-provisioners.json
