#
# RDS 
#

# DB Security Group
resource "aws_security_group" "rds_access" {
  name        = "allow_access_to_rds"
  description = "Allow traffic to rds inside private subnet"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.128.0/17"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
  }
}

# Main DB
resource "aws_db_subnet_group" "main" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private_3a.id, aws_subnet.private_4b.id]
  tags = {
    Name = "${var.project_default_tags.Project}_db_subnet_group"
  }
}

resource "aws_db_instance" "main_db" {
  allocated_storage      = 5
  instance_class         = "db.t2.small"
  engine                 = "mysql"
  engine_version         = "8.0.28"
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_access.id]
  tags = {
    Name = "${var.project_default_tags.Project}_db"
  }
}

#
# Lambda
#

# Lambda execution role
resource "aws_iam_role" "lambda_rds" {
  name = "lambda_rds"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service : "lambda.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

# Lambda policy attachment
resource "aws_iam_role_policy_attachment" "lambda_rds" {
  role       = aws_iam_role.lambda_rds.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Archiving lambda code
data "archive_file" "archive_lambda" {
  type        = "zip"
  source_dir  = "../lambda_functions/mysql-queries"
  output_path = "../lambda_functions/mysql-queries.zip"
}

# Lambda Security Group
resource "aws_security_group" "allow_lambda_rds" {
  name        = "allow_lambda_rds"
  description = "Allow traffic between main database and lambda function"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}

# Lambda function to insert data on initialization
resource "aws_lambda_function" "rds_queries" {
  filename      = data.archive_file.archive_lambda.output_path
  function_name = "lambda_rds_queries"
  role          = aws_iam_role.lambda_rds.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.7"
  environment {
    variables = {
      db_endpoint = aws_db_instance.main_db.address
      db_name     = var.db_name
      db_password = var.db_password
      db_username = var.db_username
    }
  }
  vpc_config {
    subnet_ids         = [aws_subnet.private_3a.id]
    security_group_ids = [aws_security_group.allow_lambda_rds.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_rds
  ]
}

# Invoke lambda function to initialize database
data "aws_lambda_invocation" "invoke_lambda_rds" {
  function_name = aws_lambda_function.rds_queries.function_name
  input = jsonencode({
    plug_key = "plug_value"
  })
}
