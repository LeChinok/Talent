# Talentwunder
A piece of Terraform code delpoying AWS infrastructure

The infrastructure consist of:
 An AWS ALB
 A VPC with at least 3 availability zone
 2 ECS instance (one to handle “/users” and the other to handle “/companies”)
 RDS (mysql)
