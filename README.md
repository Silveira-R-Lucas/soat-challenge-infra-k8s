# SOAT - Infraestrutura do Cluster Kubernetes (infra-k8s) - Fase 04
Este repositório gere a infraestrutura central da aplicação na AWS utilizando Terraform. Na Fase 4, a solução evoluiu para uma arquitetura de microsserviços segregados, utilizando mensageria para comunicação assíncrona e um pipeline de CI/CD focado em qualidade de código e segurança.

## 🚀 Evoluções da Fase 04
Arquitetura de Microsserviços: Segregação total dos serviços de Pedido (Order), Pagamento (Payment) e Cozinha (Kitchen).

Mensageria com RabbitMQ: Implementação de um cluster RabbitMQ para orquestrar a comunicação assíncrona entre os serviços.

Estratégia de Consumers: Implementação de workers dedicados (Consumers) para processamento de filas em background, separados das APIs síncronas.

Qualidade e Segurança: Integração com SonarCloud para análise de qualidade e Checkov para varredura de segurança em IaC.

Persistência Poliglota: Suporte para diferentes motores de base de dados conforme a necessidade do serviço (PostgreSQL, MongoDB e Redis).

## 🏗️ Recursos Provisionados
Rede (VPC): VPC configurada com sub-redes públicas (para Load Balancers) e privadas (para os nós do cluster) em múltiplas zonas de disponibilidade.

AWS EKS: Cluster Kubernetes gerido para orquestração dos pods.

AWS ECR: Repositórios de imagens imutáveis para cada microsserviço com escaneamento automático de vulnerabilidades.

RabbitMQ: Cluster de mensageria configurado internamente para comunicação entre serviços.

Recursos Kubernetes (via Helm/Terraform):

Deployment: Deploy segregado para Apps (APIs) e Consumers.

Service (LoadBalancer): Exposição externa das APIs de Pedido e Pagamento.

Secret: Gestão dinâmica de credenciais via AWS Secrets Manager.

## 🛡️ Qualidade e CI/CD
O pipeline de CI/CD no GitHub Actions garante a integridade do sistema através de:

Checkov Scan: Varredura automática de segurança nas configurações Terraform.

SonarCloud Scan: Análise estática de código para medir cobertura de testes e identificar code smells.

Terraform Test: Execução de testes de infraestrutura para validar lógicas de rede e variáveis.

## ⚙️ Configurações de Microsserviços
Cada módulo de microsserviço suporta configurações específicas para resiliência:

Probes Dinâmicas: As health probes são desativadas ou configuradas como TCP para Consumers, enquanto as APIs utilizam probes HTTP.

Init Containers: Execução automática de rails db:migrate apenas em serviços que utilizam bases relacionais (PostgreSQL).

Secret Injection: A RAILS_MASTER_KEY é injetada dinamicamente, permitindo que os Consumers utilizem a chave do serviço "pai" correspondente.

## 📋 Pré-requisitos
AWS Secrets Manager: O pipeline espera que as seguintes chaves existam previamente:

soat/db/database_url (PostgreSQL).

soat/db/mongodb_url (MongoDB).

soat/db/redis_url (Redis).

soat/<service-name>/master_key (Rails Master Key).

GitHub Secrets: Configuração de SONAR_TOKEN, AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY.

## 🛠️ Como Utilizar
O deploy é automatizado via Workflow Dispatch:

Aceda à aba Actions no GitHub.

Selecione o workflow Terraform CI/CD.

Ative a opção "Deseja realizar o deploy das aplicações?" para provisionar os microsserviços após a infraestrutura de rede estar pronta.

Para destruir a infraestrutura, utilize o workflow Terraform Destroy Infrastructure fornecendo a palavra de confirmação "destroy".
