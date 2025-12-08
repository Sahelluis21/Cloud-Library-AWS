FROM nginx:1.27-alpine

# Remove default configuration
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy our configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Force ownership (important for ECS)
RUN mkdir -p /var/www/html/public && \
    chown -R nginx:nginx /var/www/html && \
    chmod -R 755 /var/www/html

# Ensure no entrypoint scripts override our config
RUN rm -f /docker-entrypoint.d/*listen-on-ipv6-by-default.sh

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
