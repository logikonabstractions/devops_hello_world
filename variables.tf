# instance details

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ec2_instance_type" {
  type = string
  description = "Name of the instance"
  default = "t2.micro"
}

variable "instance_name" {
  type = string
  description = "Name of the instance"
  default = "Hello World ec2"
}

variable "ssh_alternate_port" {
  type    = number
  default = 333
}

# application-level

variable "app_port" {
  type    = number
  default = 8000
}

variable "ecr_repo_name" {
  type    = string
  default = "flask-hello"
}

variable "image_tag" {
  type    = string
  default = "latest"
}