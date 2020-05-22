source "amazon-ebs" "example" {
  # name = "amazon-linux-ami"?

  ami_name        = "training-amazon-linux-{{isotime | clean_resource_name}}"
  ami_description = "Linux-AMI"
  instance_type   = "t2.micro"
  region          = var.aws_region
  ssh_username    = "ec2-user"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      architecture        = "x86_64"
      name                = "*amzn-ami-hvm-*"
      root-device-type    = "ebs"

      # "block-device-mapping.volume-type" = "gp2"?

    }
    owners      = ["amazon"]
    most_recent = true
  }
}
