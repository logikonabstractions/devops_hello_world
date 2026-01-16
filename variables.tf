variable "instance_name" {
  type = string
  description = "Name of the instance"
  default = "Hello World ec2"
}

variable "ec2_instance_type" {
  type = string
  description = "Name of the instance"
  default = "t2.micro"
}


variable "ssh_alternate_port" {
  type    = number
  default = 333
}
