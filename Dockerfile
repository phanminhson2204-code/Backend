FROM php:8.2-cli

# Thiết lập thư mục làm việc
WORKDIR /app

# Cài đặt các thư viện hệ thống
RUN apt-get update && apt-get install -y \
    git curl zip unzip libzip-dev libonig-dev

# Cài đặt extension PHP
RUN docker-php-ext-install pdo_mysql mbstring zip

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy toàn bộ code
COPY . .

# Cài đặt dependencies (Bỏ qua scripts để tránh lỗi key:generate)
RUN composer install --no-dev --optimize-autoloader --no-scripts

EXPOSE 10000

# Lệnh CMD mới: Tự tạo file .env trống nếu chưa có, sau đó mới chạy Laravel
CMD sh -c "touch .env && php artisan key:generate --force && php artisan config:clear && php artisan serve --host=0.0.0.0 --port=10000"