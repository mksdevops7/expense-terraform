resource "aws_security_group" "main" {
  name        = "${var.env}-${var.component}-sg"
  description = "${var.env}-${var.component}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "RDS"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.component}-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-${var.component}"
  subnet_ids = var.subnets

  tags = {
    Name = "${var.env}-${var.component}"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.env}-${var.component}"
  engine_version          = "5.7.mysql_aurora.2.11.3"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  database_name           = "dummy"
  master_username         = data.aws_ssm_parameter.master_username
  master_password         = data.aws_ssm_parameter.master_password
  vpc_security_group_ids = [aws_security_group.main.id]
}