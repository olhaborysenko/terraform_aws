resource "aws_vpc" "test_env" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}
resource "aws_subnet" "subnet" {
  cidr_block        = cidrsubnet(aws_vpc.test_env.cidr_block, 3, 1)
  vpc_id            = aws_vpc.test_env.id
  availability_zone = "eu-west-1a"
}
resource "aws_internet_gateway" "test_env_gw" {
vpc_id = aws_vpc.test_env.id
}
resource "aws_route_table" "route_table_test_env" {
  vpc_id = aws_vpc.test_env.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_env_gw.id
  }
}
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table_test_env.id
}
resource "aws_security_group" "security" {
  name = "allow-all"
  vpc_id = aws_vpc.test_env.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "test-instance" {
  ami           = "ami-0163d8bb0e1bc3cb4"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.security.id}"]
  subnet_id = "${aws_subnet.subnet.id}"
  tags = {
    Name = "TestInstance"
  }
}
