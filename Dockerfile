FROM ghcr.io/cirruslabs/flutter:3.32.5 AS build

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web

# NGINX server
FROM nginx:alpine

# Clean default
RUN rm /etc/nginx/conf.d/default.conf

# Copy Config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Build Flutter App
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]