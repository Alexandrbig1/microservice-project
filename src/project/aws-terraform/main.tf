module "s3_backend" {
  source      = "./modules/s3-backend"           
  bucket_name = "terraform-state-bucket-001001"  
  table_name  = "terraform-locks"                
}
