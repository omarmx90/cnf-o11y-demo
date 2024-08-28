output "dashboard_url" {
  description = "URL of the Grafana dashboard"
  value       = "${var.grafana_url}d/${grafana_dashboard.example_dashboard.uid}/dashboard-epam-demo"
}
