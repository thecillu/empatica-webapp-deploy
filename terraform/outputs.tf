# outputs.tf

output "website_endpoint" {
  value = aws_s3_bucket.webapp_bucket.website_endpoint
}