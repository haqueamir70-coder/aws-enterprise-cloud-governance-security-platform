variable "name" {
  type        = string
  description = "Name prefix."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR."
}

variable "availability_zones" {
  type        = list(string)
  description = "AZs for the subnet tiers."

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Provide exactly two AZs for this lab module."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs."

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDRs."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs."

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide exactly two private subnet CIDRs."
  }
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create one NAT Gateway in first public subnet."
  default     = false
}
