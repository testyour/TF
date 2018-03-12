resource "aws_security_group" "NATSecurityGroup" {
  name = "NATSecurityGroup"
  tags {
        Name = "NATSecurityGroup"
  }
  description = "Enable internal access to the NAT device"
  vpc_id = "${aws_vpc.terraformmain.id}"

  ingress {
        from_port = "80"
        to_port = "80"
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    security_groups = ["${aws_security_group.BastionSecurityGroup.id}"]
  }
  ingress {
    from_port   = "1"
    to_port     = "65535"
    protocol    = "TCP"
    security_groups = ["${aws_security_group.InternalSshSecurityGroup.id}"]
  }
  egress {
    from_port = "1"
    to_port = "65535"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "BastionSecurityGroup" {
  name = "BastionSecurityGroup"
  tags {
        Name = "BastionSecurityGroup"
  }
  description = "Enable access to the bastion host"
  vpc_id = "${aws_vpc.terraformmain.id}"
  ingress {
      from_port = "22"
      to_port = "22"
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "InternalSshSecurityGroup" {
  name = "InternalSshSecurityGroup"
  tags {
        Name = "InternalSshSecurityGroup"
  }
  description = "Allow ssh access from bastion"
  vpc_id = "${aws_vpc.terraformmain.id}"
  ingress {
      from_port = "22"
      to_port = "22"
      protocol = "TCP"
      security_groups = ["${aws_security_group.BastionSecurityGroup.id}"]
  }
}
