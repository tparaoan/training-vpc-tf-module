resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id     = aws_eip.nat_eip.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_a.id

  tags = {
    Name = "${var.project_name}-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add a 
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}