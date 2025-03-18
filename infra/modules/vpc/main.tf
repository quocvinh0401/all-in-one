resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnets" {
    count             = length(var.public_subnets)
    vpc_id            = aws_vpc.this.id
    cidr_block        = element(var.public_subnets, count.index)
    map_public_ip_on_launch = true
    
    tags = {
        Name = "all-in-one-pb-subnet-${count.index}"
    }
}

resource "aws_subnet" "private_subnets" {
    count             = length(var.private_subnets)
    vpc_id            = aws_vpc.this.id
    cidr_block        = element(var.private_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)
    
    tags = {
        Name = "all-in-one-pv-subnet-${count.index}"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "all-in-one-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "all-in-one-public-rt"
  }
}

resource "aws_route_table_association" "rta" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}