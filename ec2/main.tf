
#################################################################################

# Here I have defined a Terraform resource to create a CNAME Record \
# for ElasticBeansTalk url.
# var.ENVIRONMENT_CNAME  is an envornment variable that has set \
# through gitlab Ci on the task Deplyoment

################################################################################
resource "aws_route53_record" "benz" {
  zone_id = data.aws_route53_zone.nasri.zone_id
  name    = "benz"
  type    = "CNAME"
  ttl     = "300"
  records = [var.ENVIRONMENT_CNAME]
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "eu-south-1"
}

#### Networking Section ##### 

resource "aws_vpc" "network_vpc" {

  cidr_block           = var.network_address_space
  enable_dns_hostnames = true
  tags = {

    Name         = "${var.environment_tag}-vpc"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag


  }


}

resource "aws_internet_gateway" "internet_vpc_gw" {
  vpc_id = aws_vpc.network_vpc.id

  tags = {

    Name         = "${var.environment_tag}-vpc-gw"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag

  }
}

resource "aws_subnet" "subnet" {

  count = var.subnet_count

  cidr_block              = cidrsubnet(var.network_address_space, 8, count.inex + 1)
  vpc_id                  = aws_vpc.network_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.avaialbe_zones.names[count.index]
  tags = {

    Name         = "${var.environment_tag}-subnet1"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag

  }

}
resource "aws_subnet" "subnet2" {


  cidr_block              = var.subnet2_network_space
  vpc_id                  = aws_vpc.network_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.avaialbe_zones.names[1]
  tags = {

    Name         = "${var.environment_tag}-subnet2"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag

  }
}

resource "aws_route_table" "vpc_rtb" {
  tags = {

    Name         = "${var.environment_tag}-vpc-rtb"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag

  }
  vpc_id = aws_vpc.network_vpc.id
  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_vpc_gw.id

  }



}
resource "aws_route_table_association" "rta-subnet1" {

  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.vpc_rtb.id

}

resource "aws_route_table_association" "rta-subnet2" {

  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.vpc_rtb.id

}

### Security Group #### 

resource "aws_security_group" "nginx-sg" {

  name   = "nginx-sg"
  vpc_id = aws_vpc.network_vpc.id
  tags = {

    Name         = "${var.environment_tag}-nginx-sg"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag

  }



  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]



  }
  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network_address_space]

  }


  egress {
    description = "to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "elb-sg" {
  name   = "elb-sg"
  vpc_id = aws_vpc.network_vpc.id
  tags = {

    Name         = "${var.environment_tag}-vpc-rtb"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag

  }


  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]



  }
  ingress {
    description = "https from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    description = "to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}





############# Instances ###############
resource "aws_instance" "vm1" {

  # lifecycle {
  #   prevent_destroy = true
  # }

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.private_key
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]


  #count         = 0
  tags = {

    Name         = "${var.environment_tag}-vpc"
    BillingCode  = var.billing_code_tag
    Environment  = var.environment_tag
    DynamicGroup = var.ansible_dynamic_tag

  }

}
