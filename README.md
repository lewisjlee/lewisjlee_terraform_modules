# This is my test GitOps repository to write Terraform code for a stable system infrastructure and provision it for test
## Partial goals to focus on(Numbers might stand for priority)
1. Provision 2 EKS Node Group, one is for web tier and the other is for was tier
2. Both of these Node Groups are in private subnets and connect to control plane and ecr etc through vpc endpoints
