terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }
  required_version = ">= 1.1.0"
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = var.tags
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.az, count.index)
  map_public_ip_on_launch = "true"

  tags = {
    Name = "web-subnet-public-${element(var.az, count.index + 1)}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.az, count.index)
  map_public_ip_on_launch = "false"

  tags = {
    Name = "web-subnet-private-${element(var.az, count.index + 1)}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "web-IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "web-rtb-public"
  }
}

resource "aws_route_table_association" "associate_public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web-instance-SG" {
  name        = "server-SG"
  description = "allow inbound/outbound traffic for the webservers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow inbound HTTPS/TLS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow inbound HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow inbound SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-instance_SG"
  }
}

resource "aws_instance" "web-instance" {
  count                       = length(var.public_subnet_cidrs)
  ami                         = var.ami
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = file("script.sh")
  key_name                    = "web.pem"
  vpc_security_group_ids      = [aws_security_group.web-instance-SG.id]
  subnet_id                   = element(aws_subnet.public_subnets[*].id, count.index)


  tags = {
    Name = "web-instance-a${count.index + 1}"
  }

}

resource "aws_security_group" "web-instance_lb_SG" {
  name        = "web-instance-lb-sg"
  description = "Allow inbound/oubound traffic for the load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow inbound HTTPS/TLS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow inbound HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-lb-sg"
  }
}

resource "aws_lb" "web-instance_lb" {
  name               = "web-instance-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-instance_lb_SG.id]
  subnets            = aws_subnet.public_subnets[*].id

}

resource "aws_lb_target_group" "web-instance_lb_TG" {
  name     = "web-instance-lb-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-instance_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:236165804395:certificate/87ee5d5c-81af-4c5f-8bfd-c7b541f1c181"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-instance_lb_TG.arn
  }
}

resource "aws_lb_target_group_attachment" "web-instance_lb_TG_ATT" {
  count            = length(var.public_subnet_cidrs)
  target_group_arn = aws_lb_target_group.web-instance_lb_TG.arn
  target_id        = element(aws_instance.web-instance[*].id, count.index)
  port             = 80
}

data "aws_route53_zone" "zone" {
  zone_id      = var.zone_id
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "terraform-test.angelifechukwu.me"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = aws_lb.web-instance_lb.dns_name
    zone_id                = aws_lb.web-instance_lb.zone_id
    evaluate_target_health = false
  }
}

# inventory file 
resource "local_file" "ip_output" {
  content  = <<EOT
  [all]
  ${aws_instance.web-instance.*.public_ip[0]}
  ${aws_instance.web-instance.*.public_ip[1]}
  ${aws_instance.web-instance.*.public_ip[2]}
  [all:vars]
  ansible_user=ubuntu
  ansible_ssh_private_key_file=/home/vagrant/web.pem
  ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT
  
  filename = "../ansible/host-inventory"
  directory_permission = "777"
  file_permission = "777"

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/host-inventory ../ansible/playbook.yml"
  }
}

