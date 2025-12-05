FROM nginx:alpine

# Remove o arquivo padrão do nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia o seu arquivo de configuração
COPY default.conf /etc/nginx/conf.d/default.conf

# Copia certificados se existirem (opcional — não interfere se a pasta estiver vazia)
COPY certs/ /etc/nginx/certs/

# Define o diretório público do PHP
# IMPORTANTE: no ECS este diretório será montado via volume compartilhado
RUN mkdir -p /var/www/html/public

# Permissões
RUN chmod -R 755 /var/www/html

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
