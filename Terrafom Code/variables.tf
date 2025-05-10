variable "instance_type" {
  description = "type of instance"
  type        = string
  default     = "t2.small"
}

variable "ami_id" {
  description = " ami id to use for the instance"
  type        = string
  default     = "ami-02b2437bed95a57e7" 
}

variable "tags_name" {
  description = "tag"
  type        = string
  default     = "DevOps-Instance"
}

variable "SG_name" {
  description = "security group"
  type        = string
  default     = "SG"
}
