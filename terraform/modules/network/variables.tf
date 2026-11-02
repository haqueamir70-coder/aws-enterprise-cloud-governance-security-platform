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
  description = "Private application subnet CIDRs."

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

variable "enable_flow_logs" {
  type        = bool
  description = "Whether to send VPC Flow Logs to CloudWatch Logs."
  default     = false
}

variable "flow_log_retention_days" {
  type        = number
  description = "CloudWatch log retention period."
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.flow_log_retention_days)
    error_message = "Use a supported CloudWatch Logs retention period."
  }
}
