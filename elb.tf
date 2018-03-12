resource "aws_elb" "elb" {
  name               = "terraform-elb"
  subnets            = ["${aws_subnet.Private.id}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  access_logs {
    bucket        = "terratest0"
    interval      = 60
  }

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = "80"
    lb_protocol       = "http"
  }

  listener {
    instance_port      = "8080"
    instance_protocol  = "http"
    lb_port            = "8080"
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.NATDevice.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "terraform-elb"
  }
}

# Create a new load balancer attachment
  resource "aws_elb_attachment" "elb_attach" {

    elb                 = "${aws_elb.elb.id}"
    instance            = "${aws_instance.NATDevice.id}"

}


#S3

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = "terratest0"
  acl    = "private"

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::terratest0/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}
