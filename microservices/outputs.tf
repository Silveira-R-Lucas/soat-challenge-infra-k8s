output "service_hostname" {
  description = "Hostname gerado pelo LoadBalancer da AWS"
  value       = try(kubernetes_service_v1.app_service.status[0].load_balancer[0].ingress[0].hostname, "")
}