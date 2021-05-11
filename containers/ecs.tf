resource "aws_ecs_task_definition" "Koffee-Luv-App-Task" {
  family                = "Koffee-Luv-App-Task"
  network_mode          = "bridge"
  execution_role_arn    = var.ecsExecutionRoleArn
  memory                = 256
  cpu                   = 128
  container_definitions = file("${path.module}/ecs-images.json")
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name = "ecs-launch-configuration"
  image_id = "ami-07a63940735aebd38"
  instance_type = "t2.micro"
  iam_instance_profile = var.ecsInstanceProfileId

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  associate_public_ip_address = "false"
  key_name = var.myLabKeyPair

  user_data = <<-EOF
        #!/bin/bash
        echo ECS_CLUSTER=Koffee-Luv-Cluster >> /etc/ecs/ecs.config;
        echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
        EOF

  security_groups = [var.EcsSG]
}


resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name = "ecs-autoscaling-group"
  max_size = "3"
  min_size = "1"
  desired_capacity = "1"

  vpc_zone_identifier = [var.appA, var.appB, var.appC]
  launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "Koffee-Luv-ECS"
    propagate_at_launch = true
  }
}

resource "aws_ecs_cluster" "Koffee-Luv-Cluster" {
  name = "Koffee-Luv-Cluster"
}

resource "aws_ecs_service" "Koffee-Luv-Home-Service" {
  name            = "Koffee-Luv-Home-Service"
  launch_type     = "EC2"
  cluster         = aws_ecs_cluster.Koffee-Luv-Cluster.id
  task_definition = "${aws_ecs_task_definition.Koffee-Luv-App-Task.family}:${aws_ecs_task_definition.Koffee-Luv-App-Task.revision}"
  desired_count   = 1
  iam_role        = var.ecsServiceRole
  deployment_minimum_healthy_percent = "100"
  deployment_maximum_percent = "200"
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = var.KoffeeLuvTGArn
    container_name   = "Koffee-Luv-Home-Container"
    container_port   = "8080"
  }

  depends_on = [null_resource.alb_exists]
}

resource "null_resource" "alb_exists" {
  triggers = {
    alb_name = "${var.KoffeeLuvAlbName}"
  }
}