variable "key_name" {
  default = "flask-ec2-key"
}

variable "instance_type" {
  default = "t3.small"
}

variable "ami_id" {
  default = "ami-001dd4635f9fa96b0" # Ubuntu 22.04 us-east-1
}

