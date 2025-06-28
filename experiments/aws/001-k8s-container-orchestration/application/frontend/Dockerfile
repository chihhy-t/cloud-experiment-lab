FROM nginx:1.25-alpine

# Install basic utilities for debugging
RUN apk add --no-cache curl

# Copy static files
COPY src/ /usr/share/nginx/html/

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Create custom error pages
RUN echo '<!DOCTYPE html><html><head><title>404 Not Found</title></head><body><h1>404 - Page Not Found</h1><p>The requested page could not be found.</p></body></html>' > /usr/share/nginx/html/404.html
RUN echo '<!DOCTYPE html><html><head><title>Server Error</title></head><body><h1>500 - Server Error</h1><p>Something went wrong on our end.</p></body></html>' > /usr/share/nginx/html/50x.html

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html
RUN chmod -R 755 /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

# Expose port
EXPOSE 80

# Labels for better container management
LABEL maintainer="cloud-experiment-lab"
LABEL service="frontend"
LABEL version="1.0"

# Create cache directories and set permissions
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp
RUN chown -R nginx:nginx /var/cache/nginx

# Use nginx user for security
USER nginx

# Start nginx
CMD ["nginx", "-g", "daemon off;"]