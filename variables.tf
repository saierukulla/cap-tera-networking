variable "vpc_cidr" {
   description = "choose cidr for vpc"
   type        = "string"
   default     = "120.13.0.0/16"
}

variable "region" {
   description = "choose region for my vpc"
   type        = "string"
   default     = "ap-south-1"
}

variable "nat_amis" {
   description = "choose a nat instance"
   type        = "map"
   default     = {
     ap-south-1 = "ami-0b44050b2d893d5f7"
 }
}
