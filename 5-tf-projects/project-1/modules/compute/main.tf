resource "aws_launch_template" "lt" {
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.ec2_sg_id]
  user_data = base64encode(<<-EOF
                            #!/bin/bash
                            dnf update -y
                            dnf install httpd -y
                            systemctl start httpd
                            systemctl enable httpd
                            EOF
  )
}

resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_autoscaling_group" "asg" {
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = [var.private_subnet_id]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}

resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_id, var.private_subnet_id]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
