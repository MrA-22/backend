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

# Salin seluruh file proyek (termasuk file database.sqlite yang sudah lengkap isinya)
COPY . .

# Konfigurasi Environment Laravel (jika belum ada .env)
RUN cp .env.example .env

# Ubah driver cache dan session ke file
RUN sed -i 's/CACHE_STORE=database/CACHE_STORE=file/g' .env || true
RUN sed -i 's/SESSION_DRIVER=database/SESSION_DRIVER=file/g' .env || true

# Pastikan folder database ada (tidak memakai 'touch' agar database.sqlite lokal Anda tidak tertimpa/reset)
RUN mkdir -p database

# Jalankan composer dump-autoload dan generate key
RUN composer dump-autoload --optimize
RUN php artisan key:generate

# Aktifkan mod_rewrite Apache
RUN a2enmod rewrite

# Konfigurasi VirtualHost Apache
RUN echo '<VirtualHost *:80> \n\
    ServerName localhost \n\
    DocumentRoot /var/www/html/public \n\
    <Directory /var/www/html/public> \n\
        Options Indexes FollowSymLinks \n\
        AllowOverride All \n\
        Require all granted \n\
    </Directory> \n\
    ErrorLog ${APACHE_LOG_DIR}/error.log \n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined \n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Set permissions menyeluruh secara aman
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type f -exec chmod 664 {} \; \
    && find /var/www/html -type d -exec chmod 775 {} \; \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache \
    && if [ -f /var/www/html/database/database.sqlite ]; then chmod 664 /var/www/html/database/database.sqlite; fi
# Bersihkan cache config
RUN php artisan config:clear && php artisan cache:clear

EXPOSE 80