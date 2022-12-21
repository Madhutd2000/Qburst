# AWS Provider

/*provider "aws" {
  region = var.region
}*/

# AWS Launch Configuration

resource "aws_launch_configuration" "practice" {
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = var.security_groups
}

# Auto Scaling Group

resource "aws_autoscaling_group" "practice" {
  launch_configuration = aws_launch_configuration.practice.id
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.vpc_zone_identifier
  //tags     = var.tags
}

# ECS Cluster

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# ECS Task Definition

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = var.ecs_task_definition_name
  //container_definitions = file("${path.module}/sample.json")
  container_definitions = var.container_definitions
}

# ECS Service Creation

resource "aws_ecs_service" "ecs_service" {
  depends_on      = [aws_lb_listener_rule.listener_rule]
  cluster         = aws_ecs_cluster.ecs_cluster.name
  //task_definition = var.task_definition
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  name            = var.ecs_service_name
  launch_type     = var.launch_type  
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.practice_tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  //network_configuration {
  //  subnets         = var.subnets
  //  security_groups = var.security_groups
  //}
}

# ALB

resource "aws_lb" "practice" {
  name                       = var.name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = var.lb_security_groups
  subnets                    = var.lb_subnets
  enable_deletion_protection = var.enable_deletion_protection
}

# Target Groups

resource "aws_lb_target_group" "practice_tg" {
  name     = var.target_group_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
}

# Listener

resource "aws_lb_listener" "practice_listener" {
  load_balancer_arn = aws_lb.practice.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.practice_tg.arn
  }
}

# Load Balancer Listerner Rule 

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.practice_listener.arn
  priority     = var.listener_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.practice_tg.arn
  }

  condition {
    path_pattern {
      values = [var.path_pattern_match]
    }
  }
}
