# ---------- Base PHP-FPM ----------
FROM php:8.1-fpm

# Recebe UID/GID do host (opcional)
ARG UID=1000
ARG GID=1000

# Temporariamente root para instalar dependências
USER root

# Atualiza pacotes e instala dependências + Nginx + Supervisor
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        unzip \
        curl \
        libpq-dev \
        libicu-dev \
        postgresql-client \
        nginx \
        supervisor \
    && docker-php-ext-install pdo pdo_pgsql intl \
    && rm -rf /var/lib/apt/lists/*

# Instala o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# Cria usuário de desenvolvimento com UID/GID do host
RUN groupadd -g $GID devgroup \
    && useradd -u $UID -g devgroup -m devuser

# ---------- Configuração Nginx ----------
# Remove default.conf padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia arquivo default.conf customizado
COPY default.conf /etc/nginx/conf.d/default.conf

# Copia certificados (opcional)
COPY certs/ /etc/nginx/certs/

# ---------- Diretórios da aplicação ----------
WORKDIR /var/www/html

# Cria pastas internas necessárias (storage, cache, uploads, public)
RUN mkdir -p storage storage/logs bootstrap/cache public/uploads

# Ajusta permissões para devuser
RUN chown -R devuser:devgroup storage bootstrap/cache public/uploads \
    && chmod -R 775 storage bootstrap/cache public/uploads

# Copia código da aplicação PHP
COPY src/ /var/www/html/

# ---------- Configura PHP para uploads grandes ----------
RUN { \
    echo 'upload_max_filesize = 3072M'; \
    echo 'post_max_size = 3072M'; \
    echo 'memory_limit = 1024M'; \
    echo 'max_execution_time = 3600'; \
    echo 'max_input_time = 3600'; \
} > /usr/local/etc/php/conf.d/uploads.ini

# ---------- Configuração do supervisord ----------
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ---------- Exposição de portas ----------
EXPOSE 80
EXPOSE 443

# ---------- Define usuário padrão ----------
USER devuser

# ---------- Comando padrão ----------
CMD ["/usr/bin/supervisord"]
