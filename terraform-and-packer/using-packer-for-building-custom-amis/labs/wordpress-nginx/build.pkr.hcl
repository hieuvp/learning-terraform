# build.pkr.hcl

# A build starts sources and runs provisioning steps on those sources.
build {
  sources = [
    # there can be multiple sources per build
    "source.amazon-ebs.example"
  ]

  # All provisioners and post-processors have a 1:1 correspondence to their
  # current layout. The argument name (ie: inline) must to be unquoted
  # and can be set using the equal sign operator (=).
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/packer/wordpress-nginx",
      "sudo chown -R ec2-user:ec2-user /opt"
    ]
  }

  provisioner "file" {
    source      = "clone-source-code.sh"
    destination = "/opt/packer/clone-source-code.sh"
  }

  provisioner "shell" {
    inline = [
      "/opt/packer/clone-source-code.sh"
    ]
  }

  # post-processors work too, example: `post-processor "shell-local" {}`.
}
