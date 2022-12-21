provider "aws" {
  region = "us-west-2"
}

module "aws_ecs_cluster" {
  source                   = "../ECS_MainModule1"
  ecs_cluster_name         = var.ecs_cluster_name
  image_id                 = var.image_id
  instance_type            = var.instance_type
  min_size                 = var.min_size
  max_size                 = var.max_size
  vpc_zone_identifier      = var.vpc_zone_identifier
  ecs_task_definition_name = var.ecs_task_definition_name
  container_definitions    = file("${path.module}/sample.json")
  ecs_service_name         = var.ecs_service_name
  //task_definition          = aws_ecs_cluster.aws_ecs_task_definition.ecs_task_definition.arn

  launch_type    = var.launch_type
  desired_count  = var.desired_count
  container_name = var.container_name
  container_port = var.container_port

  subnets         = var.subnets
  security_groups = var.security_groups

  name                       = var.name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  lb_security_groups         = var.lb_security_groups
  lb_subnets                 = var.lb_subnets
  enable_deletion_protection = var.enable_deletion_protection

  target_group_name = var.target_group_name
  port              = var.port
  protocol          = var.protocol
  vpc_id            = var.vpc_id

  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol


  listener_priority = var.listener_priority

  path_pattern_match = var.path_pattern_match

}
