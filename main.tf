terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# define a key-pair resource, already created locally 
resource "aws_key_pair" "terraform" {
  key_name   = "terraform-ec2"
  public_key = file("~/.ssh/terraform_ec2.pub")
}

resource "aws_instance" "hello" {
  # ubuntu AMI in us-east-1
  ami           = "ami-0ecb62995f68bb549"
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.terraform.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = { Name = var.instance_name }
}


# define security group that opens ssh on the instance. Above in instance definition, also attach that security group to the instance
resource "aws_security_group" "web" {
  name = "tf-ssh"
  description = "Allow SSH"
  ingress {
    description = "Alternate ssh port"
    from_port   = var.ssh_alternate_port
    to_port     = var.ssh_alternate_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # whitelist, ok for dev/testing
  }

  ingress {
    description = "Default ssh port"
    from_port   = 22
    to_port     = 22  
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # whitelist, ok for dev/testing
  }


  ingress {
    description = "Flask"
    from_port   = 8000
    to_port     = 8000  
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # whitelist, ok for dev/testing
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


