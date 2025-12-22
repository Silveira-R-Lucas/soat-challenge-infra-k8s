# Configuração global para os testes
variables {
  aws_region = "sa-east-1"
  cluster_name = "test-cluster"
  identify_client_function_url = "https://test.url/identify"
  create_user_function_url = "https://test.url/create"
  mercadopago_token = "test_token"
  mercadopago_user_id = "123"
  mercadopago_external_pos_id = "pos_123"
  mercadopago_secret = "test_secret"
}

# Teste 1: Verificar se as apps NÃO são criadas na Fase 1
run "verify_phase_1_no_apps" {
  command = plan

  variables {
    deploy_apps = false
  }

  assert {
    condition     = length(module.order_app) == 0
    error_message = "O módulo order_app não deveria ser criado quando deploy_apps é false."
  }

  assert {
    condition     = length(kubernetes_service_v1.payment_endpoint) == 0
    error_message = "O endpoint de pagamento não deveria ser criado na Fase 1."
  }
}

# Teste 2: Verificar a formação correta da URL do RabbitMQ
run "verify_rabbitmq_url_format" {
  command = plan

  assert {
    condition     = can(regex("^amqp://guest:guest@rabbitmq-service:5672$", local.rabbitmq_url))
    error_message = "A URL do RabbitMQ no locals não está formatada corretamente."
  }
}