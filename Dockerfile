# Etapa 1: build da app Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.32.5 AS build

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web

# Etapa 2: servidor NGINX
FROM nginx:alpine

# Apaga o default.conf do NGINX
RUN rm /etc/nginx/conf.d/default.conf

# Copia os ficheiros gerados para o NGINX
COPY --from=build /app/build/web /usr/share/nginx/html

# Expor a porta 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]