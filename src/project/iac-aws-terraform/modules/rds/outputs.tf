# Common outputs
output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.main.name
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = aws_db_subnet_group.main.id
}

output "security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db.id
}

output "security_group_name" {
  description = "Name of the database security group"
  value       = aws_security_group.db.name
}

output "kms_key_id" {
  description = "KMS key ID for database encryption"
  value       = var.storage_encrypted ? aws_kms_key.db[0].key_id : null
}

output "kms_key_arn" {
  description = "KMS key ARN for database encryption"
  value       = var.storage_encrypted ? aws_kms_key.db[0].arn : null
}

output "master_password" {
  description = "Master password for the database"
  value       = var.master_password != null ? var.master_password : (length(random_password.master) > 0 ? random_password.master[0].result : null)
  sensitive   = true
}

# Universal outputs (work for both RDS and Aurora)
output "db_endpoint" {
  description = "Database endpoint (works for both RDS and Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.main[0].endpoint
}

output "db_port" {
  description = "Database port (works for both RDS and Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].port : aws_db_instance.main[0].port
}

output "db_name" {
  description = "Database name (works for both RDS and Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].database_name : aws_db_instance.main[0].db_name
}

output "db_username" {
  description = "Database master username (works for both RDS and Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].master_username : aws_db_instance.main[0].username
}

output "db_engine" {
  description = "Database engine (works for both RDS and Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].engine : aws_db_instance.main[0].engine
}

output "db_engine_version" {
  description = "Database engine version (works for both RDS and Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].engine_version : aws_db_instance.main[0].engine_version
}

# RDS Instance specific outputs
output "rds_instance_id" {
  description = "RDS instance ID"
  value       = var.use_aurora ? null : aws_db_instance.main[0].id
}

output "rds_instance_arn" {
  description = "RDS instance ARN"
  value       = var.use_aurora ? null : aws_db_instance.main[0].arn
}

output "rds_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = var.use_aurora ? null : aws_db_instance.main[0].endpoint
}

output "rds_instance_address" {
  description = "RDS instance address"
  value       = var.use_aurora ? null : aws_db_instance.main[0].address
}

output "rds_instance_status" {
  description = "RDS instance status"
  value       = var.use_aurora ? null : aws_db_instance.main[0].status
}

# Aurora Cluster specific outputs
output "aurora_cluster_id" {
  description = "Aurora cluster ID"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].id : null
}

output "aurora_cluster_arn" {
  description = "Aurora cluster ARN"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].arn : null
}

output "aurora_cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_cluster_reader_endpoint" {
  description = "Aurora cluster reader endpoint"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "aurora_writer_instance_id" {
  description = "Aurora writer instance ID"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_writer[0].id : null
}

output "aurora_writer_instance_endpoint" {
  description = "Aurora writer instance endpoint"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_writer[0].endpoint : null
}

output "aurora_reader_instance_ids" {
  description = "Aurora reader instance IDs"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_reader[*].id : []
}

output "aurora_reader_instance_endpoints" {
  description = "Aurora reader instance endpoints"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_reader[*].endpoint : []
}

# Connection information for Django application
output "django_db_config" {
  description = "Database configuration for Django application"
  value = {
    ENGINE   = var.engine == "postgres" ? "django.db.backends.postgresql" : "django.db.backends.mysql"
    NAME     = var.use_aurora ? aws_rds_cluster.aurora[0].database_name : aws_db_instance.main[0].db_name
    USER     = var.use_aurora ? aws_rds_cluster.aurora[0].master_username : aws_db_instance.main[0].username
    HOST     = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.main[0].endpoint
    PORT     = var.use_aurora ? aws_rds_cluster.aurora[0].port : aws_db_instance.main[0].port
    PASSWORD = var.master_password != null ? var.master_password : random_password.master[0].result
  }
  sensitive = true
}

# Connection string for applications
output "connection_string" {
  description = "Database connection string"
  value = var.engine == "postgres" ? (
    var.use_aurora ?
    "postgresql://${aws_rds_cluster.aurora[0].master_username}:${sensitive(var.master_password != null ? var.master_password : random_password.master[0].result)}@${aws_rds_cluster.aurora[0].endpoint}:${aws_rds_cluster.aurora[0].port}/${aws_rds_cluster.aurora[0].database_name}" :
    "postgresql://${aws_db_instance.main[0].username}:${sensitive(var.master_password != null ? var.master_password : random_password.master[0].result)}@${aws_db_instance.main[0].endpoint}:${aws_db_instance.main[0].port}/${aws_db_instance.main[0].db_name}"
    ) : (
    var.use_aurora ?
    "mysql://${aws_rds_cluster.aurora[0].master_username}:${sensitive(var.master_password != null ? var.master_password : random_password.master[0].result)}@${aws_rds_cluster.aurora[0].endpoint}:${aws_rds_cluster.aurora[0].port}/${aws_rds_cluster.aurora[0].database_name}" :
    "mysql://${aws_db_instance.main[0].username}:${sensitive(var.master_password != null ? var.master_password : random_password.master[0].result)}@${aws_db_instance.main[0].endpoint}:${aws_db_instance.main[0].port}/${aws_db_instance.main[0].db_name}"
  )
  sensitive = true
}

# Parameter group outputs
output "parameter_group_name" {
  description = "Name of the parameter group"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.aurora[0].name : aws_db_parameter_group.main[0].name
}

output "parameter_group_arn" {
  description = "ARN of the parameter group"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.aurora[0].arn : aws_db_parameter_group.main[0].arn
}
