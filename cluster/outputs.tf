data "mgc_kubernetes_cluster_kubeconfig" "kubeconfig" {
  cluster_id = mgc_kubernetes_cluster.soat_cluster.id
  depends_on = [mgc_kubernetes_nodepool.main_pool]
}
output "cluster_kubeconfig_content" {
  description = "O conteúdo completo do ficheiro kubeconfig como uma string."
  value       = data.mgc_kubernetes_cluster_kubeconfig.kubeconfig.kubeconfig
  sensitive   = true
}