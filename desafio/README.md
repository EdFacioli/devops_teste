## Infraestrutura

A infraestrutura do projeto é simples, terraform-infra, possui uma vpc com três subredes publicas e três subredes privadas, ecr e ecs/fargate. Além de elastic ip, loadbalancer e natgateway.

## Deploy

O deploy é realizado utilizando terraform, terraform-deploy, uma ressalva aqui, o uso do terraform não garante que o serviço estará rodando de forma saudável, apenas garante que o recurso foi criado. Para uma solução mais requintada, uma ferramenta de deploy poderia ser escrita na qual iria acompanhar o deploy do serviço, informando no final se o serviço subiu sem problemas ou se algo impediu.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Module  | Description |
|---------|-------------|
| ecs     | criação do cluster |
| ecr     | criação do repositório para imagem |
| network | criação da infraestrutura |