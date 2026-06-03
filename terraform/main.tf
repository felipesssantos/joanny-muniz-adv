
# ==========================================
# S3 BUCKET (Hospedagem dos Arquivos)
# ==========================================
resource "aws_s3_bucket" "site_bucket" {
  bucket = "${var.project_name}-prod-website"
}

# Bloqueio total de acesso público ao S3 (Melhor prática)
resource "aws_s3_bucket_public_access_block" "site_bucket_pab" {
  bucket                  = aws_s3_bucket.site_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ==========================================
# ORIGIN ACCESS CONTROL (Segurança CloudFront -> S3)
# ==========================================
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-oac"
  description                       = "OAC para permitir o CloudFront acessar o S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Política do S3 permitindo leitura apenas pela distribuição do CloudFront
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.site_bucket.arn}/*"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}

# ==========================================
# CLOUDFRONT DISTRIBUTION
# ==========================================
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100" # Classe mais barata, atende Américas e Europa

  aliases = var.domain_names

  origin {
    domain_name              = aws_s3_bucket.site_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.site_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.site_bucket.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    dynamic "function_association" {
      for_each = var.append_index_function_arn != "" ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = var.append_index_function_arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn != "" ? var.acm_certificate_arn : null
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
    ssl_support_method             = var.acm_certificate_arn != "" ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != "" ? "TLSv1.2_2021" : "TLSv1"
  }
}