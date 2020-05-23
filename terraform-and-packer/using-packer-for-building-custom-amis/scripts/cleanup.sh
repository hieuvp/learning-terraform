#!/usr/bin/env bash

set -eou pipefail

export AWS_REGION="us-east-1"

readonly AMI_NAME="shopback-linux-*"
readonly IMAGES=$(
  aws ec2 describe-images --output json \
    --filters "Name=name,Values=${AMI_NAME}"
)

main() {
  local -r index=$1
  local -r name=$(echo "$IMAGES" | jq --raw-output ".Images[${index}].Name")
  local -r image_id=$(echo "$IMAGES" | jq --raw-output ".Images[${index}].ImageId")
  local -r snapshot_id=$(echo "$IMAGES" | jq --raw-output ".Images[${index}].BlockDeviceMappings[0].Ebs.SnapshotId")

  printf "\n"
  echo "Found A Matching AMI       : ${name}"

  echo "- Deregistering This Image : ${image_id}"
  # aws ec2 deregister-image --image-id ami-0123456789

  echo "- Deleting This Snapshot   : ${snapshot_id}"
  # aws ec2 delete-snapshot --snapshot-id snap-9876543210
}

for index in $(echo "$IMAGES" | jq '.Images | keys | .[]'); do
  main "$index"
done

printf "\n"
