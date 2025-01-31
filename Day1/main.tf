resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet1_cidr_block
  availability_zone       = var.subnet1_availability_zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet2_cidr_block
  availability_zone       = var.subnet2_availability_zone
  map_public_ip_on_launch = true
}
