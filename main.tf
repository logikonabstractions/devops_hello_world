terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# define a key-pair resource, already created locally. pathrexpand() to make it more portable
resource "aws_key_pair" "terraform" {
  key_name   = "terraform-ec2"
  public_key = file(pathexpand("~/.ssh/terraform_ec2.pub"))
}


resource "aws_instance" "hello" {
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.terraform.key_name
  vpc_security_group_ids      = [aws_security_group.web.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name

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


# ECR - registry for docker image. Create + basic confs.
resource "aws_ecr_repository" "app" {
  name    = var.ecr_repo_name
  force_delete = false                   # dev
  image_tag_mutability = "MUTABLE"      # dev

  image_scanning_configuration {
    scan_on_push = true
  }
}

# lifecyle policy -- avoid piling up pushed images
resource "aws_ecr_lifecycle_policy" "keep_recent" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = { type = "expire" }
      }
    ]
  })
}

locals {
  ecr_repo_url = aws_ecr_repository.app.repository_url
  ecr_registry = split("/", local.ecr_repo_url)[0]
  image_ref    = "${local.ecr_repo_url}:${var.image_tag}"
}

# IAM user for EC2 to read repo from ECR
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name               = "tf-flask-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "tf-flask-ec2-profile"
  role = aws_iam_role.ec2.name
}

