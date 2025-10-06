output "cluster_kubeconfig_content" {
  description = "O conteúdo do kubeconfig para o cluster EKS, gerado manualmente."
  sensitive   = true
  
  value = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = module.kubernetes_cluster.cluster_name
    clusters = [
      {
        name = module.kubernetes_cluster.cluster_name
        cluster = {
          server                   = module.kubernetes_cluster.cluster_endpoint
          certificate-authority-data = module.kubernetes_cluster.cluster_certificate_authority_data
        }
      }
    ]
    contexts = [
      {
        name = module.kubernetes_cluster.cluster_name
        context = {
          cluster = module.kubernetes_cluster.cluster_name
          user    = module.kubernetes_cluster.cluster_name
        }
      }
    ]
    users = [
      {
        name = module.kubernetes_cluster.cluster_name
        user = {
          exec = {
            apiVersion = "client.authentication.k8s.io/v1beta1"
            command    = "aws"
            args = [
              "eks",
              "get-token",
              "--cluster-name",
              module.kubernetes_cluster.cluster_name,
            ]
          }
        }
      }
    ]
  })
}