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

resource "aws_instance" "nginx" {
  ami = ""
  instance_type = ""
}
