# Etapa 1: build da app Flutter Web
FROM dart:stable AS build

WORKDIR /app

# Copiar pubspec e instalar dependências
COPY pubspec.* ./
RUN dart pub get

# Copiar resto da app e fazer build
COPY . .
RUN dart pub global activate webdev && dart pub get
RUN flutter build web

# Etapa 2: servidor NGINX para servir os ficheiros
FROM nginx:alpine

# Aponta o conteúdo gerado para o diretório de HTML do nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Remove default nginx config (opcional)
RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
