#################################################
# VARIABLES
#################################################

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "private_key_path" {}
variable "key_pair_name" {
  default = "ShopBack"
}


#################################################
# PROVIDERS
#################################################

provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = "eu-west-2"
}


#################################################
# RESOURCES
#################################################

resource "aws_instance" "nginx" {
  ami           = "ami-04de2b60dd25fbb2e"
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  connection {
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }
}


#################################################
# OUTPUT
#################################################

output "aws_instance_public_dns" {
  value = aws_instance.nginx.public_dns
}
