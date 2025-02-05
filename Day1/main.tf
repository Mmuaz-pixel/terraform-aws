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
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"

  # ensuring these ownership controls and public access block of bucket is created before doing configuration

  # needed to be debuged to check the issue

  # depends_on = [
  #   aws_s3_bucket_ownership_controls.bucket,
  #   aws_s3_bucket_public_access_block.bucket
  # ]
}


resource "aws_instance" "server1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.awssg.id
  ]
  subnet_id = aws_subnet.sub1.id
  user_data = base64encode(file("ec2_user_data.sh"))
  # we need to encode the user data as base64 for using it in aws_instance

}
resource "aws_instance" "server2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.awssg.id
  ]
  subnet_id = aws_subnet.sub2.id
  user_data = base64encode(file("ec2_user_data.sh"))

}

resource "aws_lb" "application_lb" {
  name               = "ec2-lb"
  internal           = false #public internet facing with public ip 
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.awssg.id
  ]

  subnets = [
    aws_subnet.sub1.id,
    aws_subnet.sub2.id
  ]
}

resource "aws_lb_target_group" "lb_tg" {
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#attachments to the target group for balancing between

resource "aws_lb_target_group_attachment" "tg_attachment1" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = aws_instance.server1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "tg_attachment2" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

#attaching the target group to the lb
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

