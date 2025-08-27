# Aurora Cluster (when use_aurora = true)
resource "aws_rds_cluster" "aurora" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.project_name}-${var.environment}-aurora-cluster"

  # Engine configuration
  engine         = local.aurora_engine
  engine_version = var.engine_version
  engine_mode    = "provisioned"

  # Database configuration
  database_name   = var.db_name
  master_username = var.master_username
  master_password = var.master_password != null ? var.master_password : random_password.master[0].result
  port            = local.db_port

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  # Backup configuration
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.backup_window
  preferred_maintenance_window = var.maintenance_window
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot

  # Parameter groups
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name

  # Storage configuration
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.storage_encrypted ? aws_kms_key.db[0].arn : null

  # Deletion protection
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-${var.environment}-aurora-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Enable logging
  enabled_cloudwatch_logs_exports = var.engine == "postgres" ? ["postgresql"] : ["error", "general", "slowquery"]

  # Apply immediately for dev environments
  apply_immediately = var.environment != "prod"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-aurora-cluster"
    Type = "Aurora Cluster"
  })

  lifecycle {
    ignore_changes = [
      master_password,
      final_snapshot_identifier
    ]
  }
}

# Aurora Writer Instance
resource "aws_rds_cluster_instance" "aurora_writer" {
  count = var.use_aurora ? 1 : 0

  identifier         = "${var.project_name}-${var.environment}-aurora-writer"
  cluster_identifier = aws_rds_cluster.aurora[0].id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora[0].engine
  engine_version     = aws_rds_cluster.aurora[0].engine_version

  # Parameter group
  db_parameter_group_name = aws_db_parameter_group.aurora_instance[0].name

  # Monitoring
  monitoring_interval = var.monitoring_interval

  # Performance Insights
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? 7 : null

  # Auto minor version upgrade
  auto_minor_version_upgrade = true

  # Apply immediately for dev environments
  apply_immediately = var.environment != "prod"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-aurora-writer"
    Role = "writer"
    Type = "Aurora Instance"
  })
}

# Aurora Reader Instances
resource "aws_rds_cluster_instance" "aurora_reader" {
  count = var.use_aurora ? var.aurora_replica_count : 0

  identifier         = "${var.project_name}-${var.environment}-aurora-reader-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora[0].id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora[0].engine
  engine_version     = aws_rds_cluster.aurora[0].engine_version

  # Parameter group
  db_parameter_group_name = aws_db_parameter_group.aurora_instance[0].name

  # Monitoring
  monitoring_interval = var.monitoring_interval

  # Performance Insights
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? 7 : null

  # Auto minor version upgrade
  auto_minor_version_upgrade = true

  # Apply immediately for dev environments
  apply_immediately = var.environment != "prod"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-aurora-reader-${count.index + 1}"
    Role = "reader"
    Type = "Aurora Instance"
  })
}
