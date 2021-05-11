output "BastionSG" {
  value = aws_security_group.BastionSG.id
  description = "The generated security group id"
}

output "AppSG" {
  value = aws_security_group.AppSG.id
  description = "The generated security group id"
}

output "AlbSG" {
  value = aws_security_group.AlbSG.id
  description = "The generated security group id"
}

output "EcsSG" {
  value = aws_security_group.EcsSG.id
  description = "The generated security group id"
}

output "EcsInstanceProfileId" {
  value = aws_iam_instance_profile.ecsInstanceProfile.id
  description = "The generated security group id"
}

output "ecsExecutionRoleArn" {
  value = aws_iam_role.ecsTaskExecutionRole.arn
  description = "The ARN of the task execution role"
}

output "ecsServiceRole" {
  value = aws_iam_role.ecsServiceRole.id
  description = "The ARN of the task execution role"
}
