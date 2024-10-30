resource "aws_vpc" "this" {
  cidr_block                       = var.ipv4_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = var.subnets_number

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.ipv4_cidr, var.ipv4_cidr_newbits, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-public-${local.az_suffix[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count = var.create_private_subnets ? var.subnets_number : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.ipv4_cidr, var.ipv4_cidr_newbits, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.prefix}-private-${local.az_suffix[count.index]}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_eip" "nat" {
  count = var.subnets_number

  domain = "vpc"

  tags = {
    Name = "${var.prefix}-nat-${local.az_suffix[count.index]}"
  }
}

resource "aws_nat_gateway" "this" {
  count = var.subnets_number

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.prefix}-nat-${local.az_suffix[count.index]}"
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.prefix}-rt"
  }
}

resource "aws_route_table" "private" {
  count = var.subnets_number

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.prefix}-private-${local.az_suffix[count.index]}"
  }
}

resource "aws_route" "nat" {
  count = var.subnets_number

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "public" {
  count = var.subnets_number

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_default_route_table.this.id
}

resource "aws_route_table_association" "private" {
  count = var.create_private_subnets ? var.subnets_number : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-default-sg"
  }
}
