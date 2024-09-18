# add local values

locals {
  instance-type  = "t3.medium"             // using T instance types to reduce costs
  ecs-ami        = "ami-0888ba30fd446b771" // from https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-ami-versions.html
  default_vpc_id = "vpc-04b5a6106f2cd8ea5"                      // set your existing VPC id
  subnetsIDs = {                           // set your subnets IDs
    subnet1a : "subnet-012bd7a5bb6aa5801"
    subnet1b : "subnet-03df71b634d6d927a"
  }
  custom_cidr = []   // enable SSH/web access for a given custom CIDR
  user_data_vars = { // passed to UserData scripts
    s3_bucket     = aws_s3_bucket.airflow.id
    instance_role = aws_iam_role.ecs_instance_role.name
    region        = "ap-south-1"
  }
  container_secrets = [{
    name      = "_AIRFLOW_WWW_USER_PASSWORD",
    valueFrom = aws_secretsmanager_secret.airflow_ui_admin_password.arn
  }]
  log_configuration = { // CloudWatch Logs configuration for containers
    logDriver = "awslogs",
    options = {
      awslogs-group         = "airflow",
      awslogs-region        = "ap-south-1",
      awslogs-stream-prefix = "airflow"
    },
    secretOptions = []
  }
  aws_key_pair_name = "" // EC2 key pair to configure ASGs with. If empty string, none is used and SSH traffic is disabled from outside the default VPC.
}
