variable "region" {
    description = "Please enter a AWS region to deploy server (ex. eu-north-1)"
    type        = string
    default     = ""
}

variable "instance_type" {
    description = "Enter instance type for arm64"
    type        = string
    default     = "t4g.small"
}

variable "allow_ports" {
    description = "List of default open ports on EC2"
    type        = list
    default     = ["80", "443", "22"]
}

variable "disk2" {
    description = "Size of disk 2 in Gb"
    type        = number
    default     = "2"
}

variable "disk3" {
    description = "Size of disk 3 in Gb"
    type        = number
    default     = "3"
}