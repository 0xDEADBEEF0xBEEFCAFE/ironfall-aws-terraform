variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_subnet1_cidr_block" {
  type        = string
  description = "CIDR Block for Subnet 1 in VPC"
  default     = "10.0.0.0/24"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t2.micro"
}

variable "public_key" {
  description = "SSH key for ec2-user in case if login required"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzuY++OcwcVOL0zBnr/vlF+WcZ1DKDesSZEiqat6xQZaJOlUzKdDa4kWCe14xPYlPWj5jIi7/KuiKs3P7YSpzveHqbXG+w0hZwN3l5cLDYi2MIM42IypCShxsWMOE/6JeU+IjMP71eK3V1iCKJByHy7swKzXqyE/X0Slo4WT+0ZLQe8pVcJPNWhorlAHEKiEuF1t4NiDU6NbtCVsnHkYDMhTpqB0wpZRwQEvyzfy7wzHMuj/rb420CwQ1ZLbCW4JebUckV7FW4E8sXxAI9LbYNG1Hd/WBl2xNJWBNkGk12c7gua/5sIafja6JMDjtHSk0TUSq7hVcxDxwFl2ARmj7B"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "How many instance to run"
}
