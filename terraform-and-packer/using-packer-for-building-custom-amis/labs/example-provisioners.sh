#!/usr/bin/env bash

set -eoux pipefail

packer validate example-provisioners.json
packer build example-provisioners.json
