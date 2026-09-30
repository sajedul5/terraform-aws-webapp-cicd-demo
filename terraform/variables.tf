variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "devops"
}

variable "project_name" {
  description = "Name prefix for resources"
  type        = string
  default     = "webapp-demo"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name (devops-demo.pem)"
  type        = string
  default     = "devops-demo"
}

variable "app_port" {
  description = "Port the web app is exposed on"
  type        = number
  default     = 8080
}

variable "allowed_cidr" {
  description = "CIDR allowed to reach SSH and the app"
  type        = string
  default     = "0.0.0.0/0"
}
