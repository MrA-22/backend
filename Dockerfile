FROM php:8.2-apache

# Install system dependencies & Composer
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Salin file composer terlebih dahulu
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Salin seluruh file proyek
COPY . .

# Konfigurasi Environment Laravel (jika belum ada .env)
RUN cp .env.example .env

# Jalankan composer dump-autoload dan generate key
RUN composer dump-autoload --optimize
RUN php artisan key:generate

# Set permissions untuk storage dan cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Aktifkan mod_rewrite Apache terlebih dahulu
RUN a2enmod rewrite

# Konfigurasi Apache DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# Hilangkan warning ServerName Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Buat folder database dan file sqlite kosong agar perintah artisan cache tidak error
RUN mkdir -p /var/www/html/database \
    && touch /var/www/html/database/database.sqlite \
    && chown -R www-data:www-data /var/www/html/database \
    && chmod -R 775 /var/www/html/database

# Bersihkan cache config
RUN php artisan config:clear && php artisan cache:clear

EXPOSE 80