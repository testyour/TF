resource "aws_instance" "BastionHost" {
  ami = "${lookup(var.Ami, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.Public.id}"
  vpc_security_group_ids = ["${aws_security_group.BastionSecurityGroup.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "BastionHost"
  }
}

resource "aws_instance" "NATDevice" {
  ami = "${lookup(var.Ami, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.Private.id}"
  vpc_security_group_ids = ["${aws_security_group.NATSecurityGroup.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "NATDevice"
  }
}
