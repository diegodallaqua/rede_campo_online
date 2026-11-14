FROM ghcr.io/cirruslabs/flutter:3.16.4 AS build
WORKDIR /app
ARG API_BASE_URL
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN dart run build_runner build --delete-conflicting-outputs
RUN flutter build web --release -t lib/app/main.dart \
    --dart-define=API_BASE_URL=${API_BASE_URL}

FROM nginx:alpine
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/build/web /usr/share/nginx/html