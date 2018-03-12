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
variable "aws_access_key" {
  default = ""
  description = "the user aws access key"
}
variable "aws_secret_key" {
  default = ""
  description = "the user aws secret key"
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
  default = "SH"
  description = "the ssh key to use in the EC2 machines"
}


# Launch configuration

variable "create_lc" {
  description = "Whether to create launch configuration"
  default = true
}

variable "create_asg" {
  description = "Whether to create autoscaling group"
  default = true
}

variable "name" {
  description = "Creates a unique name beginning with the specified prefix"
  default = "terraform"
}

variable "lc_name" {
  description = "Creates a unique name for launch configuration beginning with the specified prefix"
  default = "terra_lc"
}

variable "asg_name" {
  description = "Creates a unique name for autoscaling group beginning with the specified prefix"
  default = "terra_asg"
}


# Autoscaling group
variable "max_size" {
  description = "The maximum size of the auto scale group"
  default = 3
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  default = 2
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  default = 2
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  default = 300
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default = 300
}

variable "health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  default = "ELB"
}

variable "force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  default = false
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names"
  default = ["terraform-elb"]
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = "list"
  default = ["Default"]
}

variable "tags" {
  description = "A list of tag blocks. Each element should have keys named key, value, and propagate_at_launch."
  default = []
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default = "5m"
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  default = 0
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min_elb_capacity behavior."
  default = false
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events."
  default = false
}


# ELB
