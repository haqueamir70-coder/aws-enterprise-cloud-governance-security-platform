variable "aws_region" {
  description = "AWS region for the sandbox environment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short project identifier."
  type        = string
  default     = "aws-governance-lab"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "lab"

  validation {
    condition     = contains(["lab", "dev", "test"], var.environment)
    error_message = "This starter only permits lab, dev or test."
  }
}

variable "vpc_cidr" {
  description = "Non-overlapping VPC IPv4 CIDR."
  type        = string
  default     = "10.40.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "One public subnet per selected AZ."
  type        = list(string)
  default     = ["10.40.1.0/24", "10.40.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "One private application subnet per selected AZ."
  type        = list(string)
  default     = ["10.40.11.0/24", "10.40.12.0/24"]
}

variable "availability_zones" {
  description = "Two AZ names in the selected region."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "enable_nat_gateway" {
  description = "Creates one NAT Gateway when true. NAT is billable; default false."
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Creates VPC Flow Logs to CloudWatch Logs when true. Logging incurs charges."
  type        = bool
  default     = false
}

variable "flow_log_retention_days" {
  description = "CloudWatch log retention for VPC Flow Logs."
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.flow_log_retention_days)
    error_message = "Use a supported CloudWatch Logs retention period."
  }
}
