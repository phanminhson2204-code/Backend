FROM php:8.2-cli

# Thiết lập thư mục làm việc
WORKDIR /app

# Cài đặt các thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libzip-dev \
    libonig-dev

# Cài đặt các extension PHP cần thiết cho Laravel và MySQL
RUN docker-php-ext-install pdo_mysql mbstring zip

# Cài đặt Composer từ image chính thức
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy toàn bộ code vào trong container
COPY . .

# --- BƯỚC QUAN TRỌNG: KHÔNG DÙNG LỆNH CP .ENV Ở ĐÂY ---
# Chúng ta sẽ để Render tự nạp biến môi trường vào hệ thống.

# Cài đặt các gói phụ thuộc (dependencies)
RUN composer install --no-dev --optimize-autoloader

# Tạo Application Key (Nếu chưa có)
RUN php artisan key:generate

# Mở cổng 10000 (Cổng mặc định của Render)
EXPOSE 10000

# Lệnh khởi chạy: Xóa cache trước khi bật server để chắc chắn nhận DB mới
CMD php artisan config:clear && php artisan cache:clear && php artisan serve --host=0.0.0.0 --port=10000