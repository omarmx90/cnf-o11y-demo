variable "grafana_url" {
  description = "Grafana URL"
  type        = string
  default     = "http://localhost:8080/grafana/"
}

variable "grafana_api_key" {
  description = "Grafana API Key"
  type        = string
  sensitive   = true
  default     = "xxxxxx"
}
