# Declare the data source
data "aws_availability_zones" "available" {}

/* EXTERNAL NETWORG , IG, ROUTE TABLE */
resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.terraformmain.id}"
    tags {
        Name = "internet gw terraform"
    }
}

resource "aws_network_acl" "Public" {
   vpc_id = "${aws_vpc.terraformmain.id}"
   subnet_ids = ["${aws_subnet.Public.id}"]
   tags {
       Name = "PublicACL"
   }
}

resource "aws_network_acl_rule" "in_pub_100" {
      network_acl_id = "${aws_network_acl.Public.id}"
      egress = false
      protocol = "tcp"
      rule_number = 100
      rule_action = "allow"
      cidr_block =  "0.0.0.0/0"
      from_port = 80
      to_port = 80
}

resource "aws_network_acl_rule" "in_pub_101" {
      network_acl_id = "${aws_network_acl.Public.id}"
      egress = false
      protocol = "tcp"
      rule_number = 101
      rule_action = "allow"
      cidr_block =  "0.0.0.0/0"
      from_port = 443
      to_port = 443
}

resource "aws_network_acl_rule" "in_pub_102" {
      network_acl_id = "${aws_network_acl.Public.id}"
      egress = false
      protocol = "tcp"
      rule_number = 102
      rule_action = "allow"
      cidr_block =  "0.0.0.0/0"
      from_port = 22
      to_port = 22
}

resource "aws_network_acl_rule" "in_pub_103" {
      network_acl_id = "${aws_network_acl.Public.id}"
      egress = false
      protocol = "tcp"
      rule_number = 103
      rule_action = "allow"
      cidr_block =  "0.0.0.0/0"
      from_port = 1024
      to_port = 65535
}

resource "aws_network_acl_rule" "out_pub_100" {
      network_acl_id = "${aws_network_acl.Public.id}"
      egress = true
      protocol = "tcp"
      rule_number = 100
      rule_action = "allow"
      cidr_block =  "0.0.0.0/0"
      from_port = 0
      to_port = 65535
}

resource "aws_network_acl" "Private" {
    vpc_id = "${aws_vpc.terraformmain.id}"
    subnet_ids = ["${aws_subnet.Private.id}"]
    tags {
        Name = "PrivateACL"
    }
 }

 resource "aws_network_acl_rule" "in_pri_100" {
       network_acl_id = "${aws_network_acl.Private.id}"
       egress = false
       protocol = "tcp"
       rule_number = 100
       rule_action = "allow"
       cidr_block =  "0.0.0.0/0"
       from_port = 0
       to_port = 65535
 }

 resource "aws_network_acl_rule" "out_pri_100" {
       network_acl_id = "${aws_network_acl.Private.id}"
       egress = true
       protocol = "tcp"
       rule_number = 100
       rule_action = "allow"
       cidr_block =  "0.0.0.0/0"
       from_port = 0
       to_port = 65535
 }

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.terraformmain.id}"
  tags {
      Name = "Public"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.terraformmain.id}"
  tags {
      Name = "Private"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.Public.id}"
  }
}

resource "aws_eip" "forNat" {
    vpc = true
}

resource "aws_eip" "bastion" {
    vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.BastionHost.id}"
  allocation_id = "${aws_eip.bastion.id}"
}

resource "aws_nat_gateway" "Public" {
    allocation_id = "${aws_eip.forNat.id}"
    subnet_id = "${aws_subnet.Public.id}"
    depends_on = ["aws_internet_gateway.gw"]
}
