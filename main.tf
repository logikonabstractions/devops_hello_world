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

resource "aws_instance" "hello" {
  # ubuntu AMI in us-east-1
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"

  tags = { Name = "tf-hello" }
}


output "instance_id" {
  value = aws_instance.hello.id
}

output "public_ip" {
  value = aws_instance.hello.public_ip
}