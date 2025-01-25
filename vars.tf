variable "region" {
  default = "ap-south-1"
}
 variable "vpc_cidr_block" {
   default = "10.0.0.1/16"
 }
 variable "name" {
   default = "vpc-ecs"
 }
variable "tags" {
default = {
    Terraform = "true"
}
}
variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "namespace" {
  default = "development"
}
variable "container_name" {
  default = "nginx"
}
variable "container_image" {
  default = "nginxdemos/hello"
}
variable "container_port_mappings" {
  default = [
    {
      containerPort = 80,
      hostPort      = 80,
      protocol      = "tcp"
    }
  ]
}
# variable "container_log_configuration" {
#   type = object({
#     log_driver = string
#     options    = map(string)
#   })
# }

### service task

variable "stage" {
  default = "development"
}
variable "attributes" {
  default = []
}
variable "delimiter" {
  default = "-"
}
variable "ecs_launch_type" {
  default = "FARGATE"
}
variable "ignore_changes_task_definition" {
  default = false
}
variable "network_mode" {
  default = "awsvpc"
}
variable "assign_public_ip" {
  default = true
}

variable "propagate_tags" {
  default = "SERVICE"
  
}   
variable "health_check_grace_period_seconds" {
  default = 120 
  
}
variable "deployment_minimum_healthy_percent" {
  default = 100
}
variable "deployment_maximum_percent" {
  default = 200
  
}
variable "desired_count" {
  default = 1
  
}
variable "task_memory" {
  default = 2048
  
}
variable "deployment_controller_type" {
  default =    "ECS"         
}
variable "task_cpu" {
  default = 1024
}
variable "container_definition_json" {
  default = [
  {
    "name": "nginx",
    "image": "nginxdemos/hello",
    "memory": 2,
    "cpu": 1,
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/container-logs",
        "awslogs-region": "ap-south-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]

}
# variable "ecs_load_balancers" {
#   type = list(object({
#     container_name   = string
#     container_port   = number
#     target_group_arn = string
#   }))
#   description = "A list of load balancer config objects for the ECS service"
#   default = [
#     {
#       container_name   = "nginx"
#       container_port   = 80
#       target_group_arn =  "arn:aws:elasticloadbalancing:ap-south-1:<>:targetgroup/my-lb/b4432fce166941d2"
#       elb_name = "ecs-alb-service-task"
#     }
#   ]
# }
