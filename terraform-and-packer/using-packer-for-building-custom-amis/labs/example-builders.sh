#!/usr/bin/env bash

set -eoux pipefail

packer validate example-builders.json
packer build -color=false example-builders.json
