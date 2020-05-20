#################################################
# VARIABLES
#################################################

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}


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

resource "aws_key_pair" "ssh" {
  key_name   = "ShopBack"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "web_server" {

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami             = "ami-04de2b60dd25fbb2e"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ssh.key_name
  security_groups = [aws_security_group.web_server.name]

  connection {
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
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

output "aws_instance_public_ip" {
  value = aws_instance.nginx.public_ip
}

output "aws_instance_public_dns" {
  value = aws_instance.nginx.public_dns
}
