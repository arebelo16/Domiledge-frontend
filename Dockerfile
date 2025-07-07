# Etapa 1: build da app Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.32.5 AS build

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web

# Etapa 2: Servidor NGINX
FROM nginx:alpine

# Limpar config default (opcional)
RUN rm /etc/nginx/conf.d/default.conf

# Copiar config custom
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar build da app Flutter para o NGINX
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]