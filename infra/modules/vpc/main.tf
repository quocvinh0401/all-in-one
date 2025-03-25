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
    availability_zone = element(var.availability_zones, count.index)
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

resource "aws_security_group" "sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}