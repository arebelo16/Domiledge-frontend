# Stage 1: Build Flutter Web App
FROM cirrusci/flutter:3.19.6 AS build

WORKDIR /app

# Copy dependency files and install them
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the web version of the app
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Remove the default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d

# Copy the built web files to the Nginx public directory
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
