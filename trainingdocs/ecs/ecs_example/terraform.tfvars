# AWS Launch Configuration
//region          = "us-west-2"
image_id        = "ami-072aaf1b030a33b6e"
instance_type   = "t2.micro"
security_groups = ["sg-063825a4a25b3058e"]

# Auto Scaling Group

min_size            = "2"
max_size            = "3"
vpc_zone_identifier = ["subnet-0dff6581d05bd2167", "subnet-08d489fa49afac92b"]

# ECS Cluster

ecs_cluster_name = "Sample-Cluster"

# ECS Task Definition

ecs_task_definition_name = "Sample-Task-Definition"
ecs_task_definition_name_2 = "New-Task-Definition"

# ECS Service Creation

ecs_service_name = "SampleECSService"
launch_type      = "EC2"
desired_count    = "1"
container_name   = "sample-spa"
container_port   = "80"
subnets          = ["subnet-0dff6581d05bd2167", "subnet-08d489fa49afac92b"]
//security_groups              = ["sg-063825a4a25b3058e"]

# ALB

name                       = "Practice-ALB"
internal                   = "false"
load_balancer_type         = "application"
lb_security_groups         = ["sg-063825a4a25b3058e"]
lb_subnets                 = ["subnet-0dff6581d05bd2167", "subnet-08d489fa49afac92b"]
enable_deletion_protection = "true"

# Target Groups

target_group_name = "ECS-TargetGroup"
port              = 80
protocol          = "HTTP"
vpc_id            = "vpc-0b97862bbbd7e683d"

# Listener

listener_port     = 80
listener_protocol = "HTTP"

# Load Balancer Listerner Rule 

listener_priority  = 10
path_pattern_match = "/index.html"
