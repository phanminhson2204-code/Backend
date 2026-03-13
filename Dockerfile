FROM php:8.2

WORKDIR /var/www

RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libzip-dev \
    libonig-dev \
    libpng-dev

RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN cp .env.example .env

RUN composer install --no-dev --optimize-autoloader

RUN php artisan key:generate

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000