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

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.main.id

  # Confiuring the internet outbound traffic (0.0.0.0/0) to go through the internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

}

#confiuring that first subnet uses the above route table

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.vpc_route_table.id
}

#confiuring that second subnet uses the above route table

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.vpc_route_table.id
}


resource "aws_security_group" "awssg" {
  name_prefix = "ec2-sg-"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # anyone can access port 80
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # anyone can access port 22 for ssh
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # access any port to outside 
  }

  tags = {
    "name" = "ec2-sg"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "muaz-terraform-day1"
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"

  # ensuring these ownership controls and public access block of bucket is created before doing configuration
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket,
    aws_s3_bucket_public_access_block.bucket
  ]
}


resource "aws_instance" "server1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}
