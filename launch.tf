#######################
# Launch configuration
#######################
resource "aws_launch_configuration" "as_conf" {
  count = "${var.create_lc}"

  name_prefix                 = "${coalesce(var.lc_name, var.name)}-"
  image_id                    = "${lookup(var.Ami,var.region)}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.NATSecurityGroup.id}", "${aws_security_group.InternalSshSecurityGroup.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

####################
# Autoscaling group
####################
resource "aws_autoscaling_group" "ASG" {
  count = "${var.create_asg}"

  availability_zones   = ["${aws_subnet.Private.availability_zone}"]
  name_prefix          = "${coalesce(var.asg_name, var.name)}-"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  vpc_zone_identifier = ["${aws_subnet.Private.id}"]

  load_balancers            = ["${aws_elb.elb.name}"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_elb_capacity     = "${var.wait_for_elb_capacity}"
  default_cooldown          = "${var.default_cooldown}"
  force_delete              = "${var.force_delete}"
  termination_policies      = "${var.termination_policies}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  protect_from_scale_in     = "${var.protect_from_scale_in}"

  tags = ["${concat(
      list(map("key", "Name", "value", var.name, "propagate_at_launch", true)),
      var.tags
   )}"]
}
