module "vpc" {

  name = "${format("%s.%s.%s.vpc")}"

  cidr = "${var.vpc_cidr}"

  private_subnets     = "${split(",",var.Subnet_Private)}"
  public_subnets      = "${split(",",var.Subnet_Public)}"

  enable_nat_gateway = true

  enable_dhcp_options              = true
  enable_dns_hostnames             = true
  enable_dns_support               = true
  dhcp_options_domain_name         = "ec2.internal"
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

}
