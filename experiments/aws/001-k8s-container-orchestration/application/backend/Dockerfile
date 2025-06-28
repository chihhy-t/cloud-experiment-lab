FROM nginx:1.25-alpine

# Install basic utilities for debugging
RUN apk add --no-cache curl

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Create a simple index page for root access
RUN echo '{"service":"backend-api","status":"running","message":"Use specific API endpoints"}' > /usr/share/nginx/html/index.json

# Set proper permissions
RUN chown -R nginx:nginx /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

# Expose port
EXPOSE 80

# Labels for better container management
LABEL maintainer="cloud-experiment-lab"
LABEL service="backend"
LABEL version="1.0"

# Create cache directories and set permissions
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp
RUN chown -R nginx:nginx /var/cache/nginx

# Use nginx user for security
USER nginx

# Start nginx
CMD ["nginx", "-g", "daemon off;"]