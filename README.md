Cloud Library 🚀

Cloud Library é uma aplicação de armazenamento de arquivos e compartilhamento em rede segura. Este manual detalha passo a passo como configurar e rodar o projeto na AWS.
📋 Pré-requisitos

Antes de iniciar, verifique se você possui:

    AWS CLI instalado e configurado

    Terraform instalado

    pgAdmin4 (opcional, para configuração visual do banco)

🚀 Configuração do Projeto
Passo 1 — Clonar o repositório

No seu terminal, execute:
bash

git clone <URL_DO_REPOSITORIO>
cd cloud-library

Passo 2 — Configurar AWS CLI

    Abra o console da AWS e vá em Details

    Configure sua CLI local:
    bash

aws configure

    Forneça as credenciais:

        AWS Access Key ID

        AWS Secret Access Key

        Região padrão

        Formato padrão (json)

Passo 3 — Criar repositórios no ECR

    No console da AWS, acesse o Elastic Container Registry (ECR)

    Crie dois repositórios:

        cloud-library-php

        cloud-library-nginx

    Para cada repositório:

        Clique em View push commands

        Siga as instruções da AWS:

            Para nginx: execute os comandos dentro da pasta nginx/

            Para php: execute os comandos dentro da pasta php/

Passo 4 — Provisionar infraestrutura com Terraform

    No terminal, entre na pasta infra:
    bash

cd infra

Execute os comandos Terraform:
bash

terraform init
terraform plan

Verifique se não há mensagens de erro

Se estiver tudo certo, aplique a configuração:
bash

terraform apply

    Nota: Isso criará todos os recursos necessários na AWS, incluindo ECS e RDS.

Passo 5 — Configuração do banco de dados PostgreSQL
🔥 Opção A — Usando pgAdmin4 (recomendado para visualização)

    Instale o pgAdmin4 no seu computador

    No Security Group do RDS, libere seu IP para permitir conexão

    Conecte-se ao banco usando os dados do RDS:

        Host: endpoint do RDS

        Porta: 5432

        Usuário/Senha: conforme configurado no RDS

    No pgAdmin, utilize o editor SQL para criar tabelas, schemas e popular dados iniciais

⚙️ Opção B — Usando linha de comando

    Conecte-se ao banco via terminal:
    bash

psql -h <RDS_ENDPOINT> -U <USUARIO> -d <NOME_DB>

    Execute seus scripts SQL

🌐 Configuração do Load Balancer

    Acesse o AWS Console

    Navegue até EC2 → Load Balancer

    Localize o Load Balancer criado pelo Terraform

    Verifique se o status está Active

    Acesse o DNS Name do Load Balancer para testar a aplicação

🧪 Testando a Aplicação

    Após a configuração completa, acesse o DNS do Load Balancer no navegador

    Verifique se a aplicação está respondendo corretamente

    Teste o upload e download de arquivos

    Verifique os logs no CloudWatch se necessário

🛠️ Solução de Problemas Comuns
Problema: Imagens não são enviadas para o ECR

    Verifique se os comandos foram executados nas pastas corretas

    Confirme as permissões do IAM

Problema: Terraform não aplica as mudanças

    Execute terraform refresh para sincronizar o estado

    Verifique as credenciais da AWS CLI

Problema: Banco de dados não conecta

    Verifique o Security Group do RDS

    Confirme se o endpoint está correto

    Teste a conectividade com telnet <RDS_ENDPOINT> 5432