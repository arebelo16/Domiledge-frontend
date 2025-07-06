# Stage 1: Build the Flutter Web App
FROM ghcr.io/cirruslabs/flutter:3.19.6 AS build

WORKDIR /app

# Copy dependency definitions and install them
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application source code
COPY . .

# Build the web version in release mode
RUN flutter build web --release

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Remove the default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy a custom NGINX config
COPY nginx.conf /etc/nginx/conf.d

# Copy the built web files from the previous stage
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
