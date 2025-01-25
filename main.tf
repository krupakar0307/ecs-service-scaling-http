provider "aws" {
  region = var.region
}
terraform {
  required_version = ">= 1.0.0"
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.25.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/2.1.1"
  name       = var.name
  ipv4_primary_cidr_block = "10.0.0.0/16"
  tags       = var.tags
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/2.4.2"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
#   cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
  tags                 = var.tags
}

resource "aws_ecs_cluster" "default" {
  name = module.label.id
  tags = module.label.tags
}

module "container_definition" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.61.1"
  container_name               = var.container_name
  container_image              = var.container_image
  container_memory             = 2
  container_cpu                = 1
  port_mappings                = var.container_port_mappings
#   log_configuration            = var.container_log_configuration
}

module "ecs_alb_service_task" {
  source = "cloudposse/ecs-alb-service-task/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.77.0"
  namespace                          = var.namespace
  stage                              = var.stage
  name                               = var.name
  attributes                         = var.attributes
  delimiter                          = var.delimiter
  enable_ecs_managed_tags            = true
  availability_zone_rebalancing      = "ENABLED"
  alb_security_group                 = module.vpc.vpc_default_security_group_id
  container_definition_json          = module.container_definition.json_map_encoded_list
  ecs_cluster_arn                    = aws_ecs_cluster.default.arn
  launch_type                        = var.ecs_launch_type
  vpc_id                             = module.vpc.vpc_id
  security_group_ids                 = [module.vpc.vpc_default_security_group_id]
  subnet_ids                         = module.subnets.public_subnet_ids
  tags                               = var.tags
  ignore_changes_task_definition     = var.ignore_changes_task_definition
  network_mode                       = var.network_mode
  assign_public_ip                   = var.assign_public_ip
  propagate_tags                     = var.propagate_tags
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_controller_type         = var.deployment_controller_type
  desired_count                      = var.desired_count
  task_memory                        = var.task_memory
  task_cpu                           = var.task_cpu
  ecs_load_balancers                 = var.ecs_load_balancers
  
}
