resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "web" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.web_subnet_cidr_block

  tags = {
    Name = "web-subnet"
  }
}

resource "aws_subnet" "app" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.app_subnet_cidr_block

  tags = {
    Name = "app-subnet"
  }
}

resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnet_cidr_block

  tags = {
    Name = "db-subnet"
  }
}

resource "aws_route_table" "web-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "web-rtb-assoc" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.web-rtb.id
}

resource "aws_route_table" "app-db-rtb" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "app-rtb-assoc" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.app-db-rtb.id
}

resource "aws_route_table_association" "db-rtb-assoc" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.app-db-rtb.id
}

resource "aws_security_group" "web-sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app-sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.web-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.app-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
