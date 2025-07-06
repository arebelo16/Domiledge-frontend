# Etapa 1: Build da app Flutter web
FROM dart:stable AS build

WORKDIR /app

# Copiar pubspec antes para fazer cache das dependências
COPY pubspec.* ./
RUN dart pub get

# Copiar o resto da app
COPY . .

# Build Flutter Web
RUN dart pub global activate flutter_tools && \
    flutter build web --release

# Etapa 2: Servir com NGINX
FROM nginx:alpine

# Remove config default do NGINX
RUN rm /etc/nginx/conf.d/default.conf

# Copia config customizada do NGINX
COPY nginx.conf /etc/nginx/conf.d

# Copia os ficheiros web para servir
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
