FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Adiciona sua config
COPY default.conf /etc/nginx/conf.d/default.conf

# Cria diretório da aplicação
RUN mkdir -p /var/www/html/public

# Define permissões
RUN chown -R nginx:nginx /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
