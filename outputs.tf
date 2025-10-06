output "cluster_kubeconfig_content" {
  description = "O conteúdo do kubeconfig para o cluster EKS, pronto para ser usado pelo kubectl."
  value       = module.kubernetes_cluster.kubeconfig
  sensitive   = true
}