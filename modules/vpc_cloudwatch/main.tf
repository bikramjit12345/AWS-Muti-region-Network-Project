resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = var.log_group_name
  retention_in_days = var.retention_in_days

  tags = var.tags
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "${var.name}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "${var.name}-vpc-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
  traffic_type         = var.traffic_type
  vpc_id               = var.vpc_id
  log_destination_type = "cloud-watch-logs"
  tags                 = var.tags
}
