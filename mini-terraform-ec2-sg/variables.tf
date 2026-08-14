variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name for SSH access"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance"
  type        = string
  default     = "0.0.0.0/0"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "mini-ec2-sg"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "mini-ec2-instance"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "dev"
}
