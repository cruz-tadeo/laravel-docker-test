FROM php:8.1-fpm-alpine

# Instala dependencias
RUN apk --no-cache add \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    freetype \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \ 
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    vim \
    unzip \
    git \
    curl


# Limpia la caché
RUN rm -rf /var/cache/apk/*

# Instala extensiones PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establece el directorio de trabajo
WORKDIR /var/www

# Copia el código de la aplicación Laravel
COPY . /var/www

# Instala las dependencias de la aplicación
RUN composer install

# Ejecuta el servidor web de desarrollo de Laravel
CMD php artisan serve --host=0.0.0.0 --port=8080

# Expone el puerto 8080
EXPOSE 8080