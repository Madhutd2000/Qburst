# AWS Launch Configuration

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

# Auto Scaling Group

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "vpc_zone_identifier" {
  type = list(string)
}

# ECS Cluster

variable "ecs_cluster_name" {
  type = string
}

# ECS Task Definition

variable "ecs_task_definition_name" {
  type = string
}

variable "ecs_task_definition_name_2" {
  type = string
}

/*variable "container_definitions" {
  type = string
}
*/

# ECS Service Creation

variable "ecs_service_name" {
  type = string
}

variable "launch_type" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "subnets" {
  type = list(string)
}

# ALB

variable "name" {
  type = string
}

variable "internal" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "lb_security_groups" {
  type = list(any)
}

variable "enable_deletion_protection" {
  type = bool
}

variable "lb_subnets" {
  type = list(string)
}

# Target Groups

variable "target_group_name" {
  type = string
}

variable "protocol" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "port" {
  type = number
}

# Listener

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

# Load Balancer Listerner Rule

variable "listener_priority" {
  type = number
}

variable "path_pattern_match" {
  type = string
}
