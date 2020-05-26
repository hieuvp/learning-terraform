#!/usr/bin/env bash

set -eoux pipefail

packer validate example-builders.json
packer build example-builders.json
