build {
  sources = [
    "source.amazon-ebs.example"
  ]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/packer",
      "sudo mkdir -p /opt/packer/nginx",
      "sudo chown -R ec2-user:ec2-user /opt"
    ]
  }

  provisioner "file" {
    source      = "example-wordpress-nginx.sh"
    destination = "/opt/packer/example-wordpress-nginx.sh"
  }

  provisioner "shell" {
    inline = [
      "/opt/packer/example-wordpress-nginx.sh"
    ]
  }
}
