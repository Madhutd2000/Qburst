/*# ECS Launch Configuration output

output "ecs_launch_configuration_config" {
  description = "The configuration deatils of the ECS launch Configuration"
  value       = aws_launch_configuration.practice
}

# ECS Auto Scaling Group output

output "ecs_asg_config" {
  description = " The configuration details of the Auto scaling Group"
  value       = aws_autoscaling_group.practice
}

# ECS Cluster output

output "ecs_cluster_config" {
  description = " The configuration details of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster
}*/

output "loadbalancer_name" {
  value = module.aws_ecs_cluster.loadbalancer_name
}
