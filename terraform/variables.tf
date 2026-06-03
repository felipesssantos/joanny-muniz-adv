variable "project_name" {
  description = "Nome base para os recursos do projeto"
  default     = "lp-joanny-muniz"
}

variable "domain_names" {
  description = "Lista de domínios customizados (ex: ['joannymuniz.adv.br', 'www.joannymuniz.adv.br'])"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "O ARN do certificado ACM já criado na AWS"
  type        = string
  default     = ""
}

variable "append_index_function_arn" {
  description = "O ARN da CloudFront Function que adiciona index.html no final das URLs"
  type        = string
  default     = ""
}
