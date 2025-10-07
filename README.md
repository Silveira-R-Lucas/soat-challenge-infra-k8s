# SOAT - Infraestrutura do Cluster Kubernetes (infra-k8s)

Este repositório é responsável por gerenciar a infraestrutura central da aplicação na AWS usando Terraform. Ele provisiona a rede, o cluster Kubernetes (EKS), o registro de contêineres (ECR) e realiza o deploy da aplicação Rails.

---

### Função no Projeto

Este é o repositório principal da infraestrutura. Sua responsabilidade é criar a "fundação" onde a aplicação irá rodar. Ele depende que a imagem da aplicação já tenha sido criada e enviada para o ECR pelo repositório `soat-challenge-backend-rails`.

### Recursos Provisionados

* **VPC:** Uma Virtual Private Cloud (`soat-challenge-vpc`) para isolar os recursos da rede.
* **Sub-redes:** Sub-redes públicas e privadas distribuídas em múltiplas zonas de disponibilidade para alta disponibilidade.
* **NAT Gateway:** Permite que os recursos em sub-redes privadas (como os nós do EKS) acessem a internet sem serem expostos publicamente.
* **AWS EKS:** Um cluster Kubernetes gerenciado (`soat-challenge-cluster`) onde a aplicação será executada.
* **AWS ECR:** Um repositório de contêineres (`soat-challenge/rails-app`) para armazenar as imagens Docker da aplicação.
* **Kubernetes Resources:**
    * `Deployment`: Define como executar os pods da aplicação Rails.
    * `Service (LoadBalancer)`: Expõe a aplicação para a internet através de um Load Balancer da AWS.
    * `Secret`: Gerencia a `DATABASE_URL` para a aplicação.

### Pré-requisitos

1.  **Conta AWS:** Acesso a uma conta AWS com permissões para criar os recursos acima.
2.  **Terraform:** Instalado localmente para testes (versão 1.0+).
3.  **AWS CLI:** Instalada e configurada com credenciais.
4.  **GitHub Secrets:** As seguintes secrets devem ser configuradas no repositório:
    * `AWS_ACCESS_KEY_ID`
    * `AWS_SECRET_ACCESS_KEY`
    * `RAILS_MASTER_KEY` (e outras secrets da aplicação Rails)
5.  **Segredo da `DATABASE_URL`:** O pipeline deste repositório espera que o segredo `soat/db/database_url` já exista no AWS Secrets Manager (ele é criado pelo pipeline do `soat-challenge-infra-db`).

### Como Utilizar

O deploy é totalmente automatizado via GitHub Actions.

1.  **Desenvolvimento:** Crie uma nova branch para fazer alterações no código Terraform.
2.  **Pull Request:** Abra um Pull Request para a branch `main`. O pipeline irá rodar um `terraform plan` para validar as mudanças e mostrar o plano de execução.
3.  **Merge:** Após a aprovação e o merge na `main`, o pipeline `terraform-ci-cd.yml` será acionado.
4.  **Deploy:** O workflow executará `terraform apply -auto-approve`, aplicando as mudanças de infraestrutura na AWS.
5.  **Saída do Kubeconfig:** Ao final, o pipeline extrai o `kubeconfig` do cluster e o salva no AWS Secrets Manager sob o nome `soat/k8s/kubeconfig` para acesso futuro.
