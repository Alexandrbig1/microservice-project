variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}
variable "image_tag_mutability" {
  description = "Whether the image tags in the repository are mutable or immutable"
  type        = string
  default     = "MUTABLE"
}
variable "force_delete" {
  description = "Whether to force delete the repository"
  type        = bool
  default     = true
}