variable "region" {
  default = "us-east-1"
}
variable "Ami" {
  type = "map"
  default = {
    "us-east-1" = "ami-428aa838"
		"us-east-2" = "ami-f63b1193"
		"us-west-1" = "ami-824c4ee2"
		"us-west-2" = "ami-f2d3638a"
  }
}
variable "vpc_cidr" {
    default = "10.0.0.0/16"
  description = "the vpc cdir"
}
variable "Subnet_Public" {
  default = "10.0.0.0/24"
  description = "the cidr of the public subnet"
}
variable "Subnet_Private" {
  default = "10.0.1.0/24"
  description = "the cidr of the private subnet"
}
variable "key_name" {
  default = ""
  description = "the ssh key to use in the EC2 machines"
}
