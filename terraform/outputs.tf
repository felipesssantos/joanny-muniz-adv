# ==========================================
# OUTPUT
# ==========================================
output "cloudfront_url" {
  description = "A URL temporária gerada pelo CloudFront para acessar a Landing Page"
  value       = aws_cloudfront_distribution.cdn.domain_name
}
