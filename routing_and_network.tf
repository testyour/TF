# Declare the data source
data "aws_availability_zones" "available" {}

/* EXTERNAL NETWORG , IG, ROUTE TABLE */
resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.terraformmain.id}"
    tags {
        Name = "internet gw terraform generated"
    }
}

resource "aws_network_acl" "Public" {
   vpc_id = "${aws_vpc.terraformmain.id}"
   egress {
       protocol = "6"
       rule_no = "100"
       action = "allow"
       cidr_block =  "0.0.0.0/0"
       from_port = "0"
       to_port = "65535"
    }
    ingress {
        protocol = "6"
        rule_no = "100"
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = "80"
        to_port = "80"
    }
    ingress {
        protocol = "6"
        rule_no = "101"
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = "443"
        to_port = "443"
    }
    ingress {
        protocol = "6"
        rule_no = "102"
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = "22"
        to_port = "22"
    }
    ingress {
        protocol = "6"
        rule_no = "103"
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = "1024"
        to_port = "65535"
    }
    tags {
        Name = "open acl"
    }
}

resource "aws_network_acl" "Private" {
   vpc_id = "${aws_vpc.terraformmain.id}"
   egress {
        protocol = "6"
        rule_no = "100"
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = "0"
        to_port = "65535"
    }
    ingress {
        protocol = "6"
        rule_no = "100"
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = "80"
        to_port = "80"
    }
    tags {
        Name = "open acl"
    }
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
    vpc      = true
}
resource "aws_nat_gateway" "Public" {
    allocation_id = "${aws_eip.forNat.id}"
    subnet_id = "${aws_subnet.Public.id}"
    depends_on = ["aws_internet_gateway.gw"]
}
