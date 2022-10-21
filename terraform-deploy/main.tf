# Taskdefinition
resource "aws_ecs_task_definition" "main" {
  family = "${var.app_name}-app"

  container_definitions = <<EOF
  [
    {
      "name": "${var.app_name}-app",
      "image": "${var.url_repository}:${var.tag}",
      "entryPoint": [],
      "environment": [
          {
            "name": "DEVOPSTESTE_PORT",
            "value": "${var.container_port}"
          },
          {
            "name": "DEVOPSTESTE_NAME",
            "value": "${var.msg}"
          }
        ],
      "essential": true,
      "healthCheck": {
        "command": [ "CMD-SHELL", "curl -f http://localhost:${var.container_port}/ping || exit 1" ],
        "interval": 20,
        "timeout": 5,
        "retries": 3
      },
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.main.id}",
          "awslogs-region": "sa-east-1",
          "awslogs-stream-prefix": "${var.app_name}-${var.environment_id}"
        },
        "secretOptions": []
      },
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.container_port},
          "hostPort": ${var.container_port}
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  tags = {
    Name        = "${var.app_name}-app"
    Environment = var.environment_id
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.main.family
}

# IAM
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.app_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
  tags = {
    Name        = "${var.app_name}-execution-task-role"
    Environment = var.environment_id
  }
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" 
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_aws_ops_works_cloud_watch_logs" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs" 
}

# Service
resource "aws_ecs_service" "service" {
  name                 = "${var.app_name}-service"
  cluster              = var.cluster_id
  task_definition      = aws_ecs_task_definition.main.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = var.subnets_private
    assign_public_ip = false
    security_groups = [
      aws_security_group.service.id,
      aws_security_group.load_balancer.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "${var.app_name}-app"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.main]
}

# Security Group Service
resource "aws_security_group" "service" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-service"
    Environment = var.environment_id
  }
}

# Loadbalancer
resource "aws_alb" "main" {
  name               = "${var.app_name}-main"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets_public
  security_groups    = [aws_security_group.load_balancer.id]

  tags = {
    Name        = "${var.app_name}-main"
    Environment = var.environment_id
  }
}

# Security Group Load Balancer
resource "aws_security_group" "load_balancer" {
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-load-balancer"
    Environment = var.environment_id
  }
}

resource "aws_lb_target_group" "main" {
  name                 = "${var.app_name}-main"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 120

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/ping"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-main"
    Environment = var.environment_id
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${var.app_name}-service"

  tags = {
    Application = "${var.app_name}-cloudwatch-log-group"
    Environment = var.environment_id
  }
}
