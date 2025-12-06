FROM php:8.1-fpm

USER root

# Instala dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    curl \
    libpq-dev \
    libicu-dev \
    postgresql-client \
    && docker-php-ext-install pdo pdo_pgsql intl mbstring tokenizer xml opcache \
    && rm -rf /var/lib/apt/lists/*

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

# Cria diretórios necessários
RUN mkdir -p /var/www/html/storage \
    /var/www/html/storage/logs \
    /var/www/html/bootstrap/cache \
    /var/www/html/public/uploads

# Ajusta permissões para o PHP-FPM (www-data)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/public/uploads

# Configura PHP
RUN { \
    echo 'upload_max_filesize = 3072M'; \
    echo 'post_max_size = 3072M'; \
    echo 'memory_limit = 1024M'; \
    echo 'max_execution_time = 3600'; \
    echo 'max_input_time = 3600'; \
} > /usr/local/etc/php/conf.d/uploads.ini

# Configura OPcache para produção
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=256'; \
    echo 'opcache.max_accelerated_files=20000'; \
    echo 'opcache.validate_timestamps=0'; \
} > /usr/local/etc/php/conf.d/opcache.ini

CMD ["php-fpm"]
