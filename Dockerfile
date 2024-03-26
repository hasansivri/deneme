# Nginx imajını temel al
FROM nginx

# Özel yapılandırma dosyasını kopyala
COPY ../configs/nginx.conf /etc/nginx/nginx.conf


# Opsiyonel olarak, statik web içeriğini kopyala (örneğin, html dosyaları)
# COPY static-html-directory /usr/share/nginx/html

# Port 80'i dışa aç
EXPOSE 80

# Nginx'i başlat
CMD ["nginx", "-g", "daemon off;"]

