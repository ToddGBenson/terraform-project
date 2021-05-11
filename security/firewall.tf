resource "aws_security_group" "BastionSG" {
  name        = "BastionSG"
  description = "Allow ssh"
  vpc_id      = var.vpc_id

  tags = {
    Name = "BastionSG"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["174.26.137.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "AppSG" {
  name        = "AppSG"
  description = "Allow ssh"
  vpc_id      = var.vpc_id

  tags = {
    Name = "AppSG"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    security_groups = [aws_security_group.BastionSG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "AlbSG" {
  name        = "AlbSG"
  description = "Allow ssh"
  vpc_id      = var.vpc_id

  tags = {
    Name = "AlbSG"
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "EcsSG" {
  name        = "EcsSG"
  description = "Allow ssh"
  vpc_id      = var.vpc_id

  tags = {
    Name = "EcsSG"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    security_groups = [aws_security_group.BastionSG.id]
  }

  ingress {
    from_port   = "32768"
    to_port     = "65535"
    protocol    = "TCP"
    security_groups = [aws_security_group.AlbSG.id]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    security_groups = [aws_security_group.AlbSG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}