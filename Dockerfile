FROM php:8.2-apache

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar archivos de Laravel al contenedor
COPY . /var/www/html/

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Dar permisos a Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Habilitar rewrite module en Apache
RUN a2enmod rewrite

# Exponer el puerto
EXPOSE 80
