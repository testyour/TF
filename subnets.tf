resource "aws_subnet" "Public" {
  vpc_id = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.Subnet_Public}"
  tags {
        Name = "Public"
  }
 availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_route_table_association" "Public" {
    subnet_id = "${aws_subnet.Public.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_subnet" "Private" {
  vpc_id = "${aws_vpc.terraformmain.id}"
  cidr_block = "${var.Subnet_Private}"
  tags {
        Name = "Private"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_route_table_association" "Private" {
    subnet_id = "${aws_subnet.Private.id}"
    route_table_id = "${aws_route_table.private.id}"
}
