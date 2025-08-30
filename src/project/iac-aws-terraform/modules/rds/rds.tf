# RDS Instance (when use_aurora = false)
resource "aws_db_instance" "main" {
  count = var.use_aurora ? 0 : 1

  identifier = "${var.project_name}-${var.environment}-db"

  # Engine configuration
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  # Storage configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.storage_encrypted ? aws_kms_key.db[0].arn : null

  # Database configuration
  db_name  = var.db_name
  username = var.master_username
  password = var.master_password != null ? var.master_password : random_password.master[0].result
  port     = local.db_port

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false

  # High availability
  multi_az = var.multi_az

  # Backup configuration
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  copy_tags_to_snapshot   = var.copy_tags_to_snapshot

  # Parameter group
  parameter_group_name = aws_db_parameter_group.main[0].name

  # Monitoring
  monitoring_interval = var.monitoring_interval

  # Performance Insights
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? 7 : null

  # Deletion protection
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-${var.environment}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Auto minor version upgrade
  auto_minor_version_upgrade = true

  # Apply immediately for dev environments
  apply_immediately = var.environment != "prod"

  # Enable logging
  enabled_cloudwatch_logs_exports = var.engine == "postgres" ? ["postgresql"] : ["error", "general", "slowquery"]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-db"
    Type = "RDS Instance"
  })

  lifecycle {
    ignore_changes = [
      password,
      final_snapshot_identifier
    ]
  }
}
