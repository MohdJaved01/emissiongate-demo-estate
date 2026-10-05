# synthetic: true - demo pull request: a new GPU fleet for a staging experiment, added by
# hand with no schedule. EmissionGate's PR gate checks its carbon before merge.

resource "aws_launch_template" "gpu_fleet" {
  provider      = aws.us_east_1
  name          = "eg-gpu-fleet"
  image_id      = var.ami_x86_64
  instance_type = "g5.2xlarge"
}

resource "aws_autoscaling_group" "gpu_fleet" {
  provider           = aws.us_east_1
  name               = "eg-gpu-fleet"
  availability_zones = ["us-east-1a", "us-east-1b"]
  min_size           = 2
  max_size           = 2
  desired_capacity   = 2

  launch_template {
    id      = aws_launch_template.gpu_fleet.id
    version = "$Latest"
  }

  tag {
    key                 = "Environment"
    value               = "staging"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "ml-platform"
    propagate_at_launch = true
  }
}
