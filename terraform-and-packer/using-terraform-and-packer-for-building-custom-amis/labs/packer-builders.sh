#!/usr/bin/env bash

set -eoux pipefail

packer validate packer-builders.json

packer build packer-builders.json
