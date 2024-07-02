resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags       = local.vpc_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "web" {
  count             = length(var.web_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_cidr[count.index]
  tags              = local.web_subnet_tags
  availability_zone = var.azs[count.index]
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.main.id
  tags   = local.web_rt_tags

  route {
    cidr_block                = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

}

resource "aws_eip" "main" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.web.*.id[0]
  tags          = local.ngw_tags
}


resource "aws_route_table_association" "web" {
  count          = length(aws_subnet.web.*.id)
  route_table_id = aws_route_table.web.id
  subnet_id      = aws_subnet.web.*.id[count.index]
}

resource "aws_subnet" "app" {
  count             = length(var.app_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidr[count.index]
  tags              = local.app_subnet_tags
  availability_zone = var.azs[count.index]
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id
  tags   = local.app_rt_tags

  route {
    cidr_block                = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

}

resource "aws_route_table_association" "app" {
  count          = length(aws_subnet.app.*.id)
  route_table_id = aws_route_table.app.id
  subnet_id      = aws_subnet.app.*.id[count.index]
}

resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidr[count.index]
  tags              = local.db_subnet_tags
  availability_zone = var.azs[count.index]
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags   = local.db_rt_tags

  route {
    cidr_block                = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

resource "aws_route_table_association" "db" {
  count          = length(aws_subnet.db.*.id)
  route_table_id = aws_route_table.db.id
  subnet_id      = aws_subnet.db.*.id[count.index]
}

resource "aws_vpc_peering_connection" "main" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
}

resource "aws_route" "main-vpc" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "default-vpc" {
  route_table_id            = var.default_vpc_rt
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}


resource "aws_security_group" "main" {
  name        = "test-${var.env}"
  description = "test-${var.env}"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Port"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0f50ed9b20e509fac"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = aws_subnet.app.*.id[0]

  tags = {
    Name = "test"
  }
}