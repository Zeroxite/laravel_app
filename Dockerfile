# Usa una imagen base de PHP con Apache
FROM php:8.0.2-apache

# Habilita el módulo de Apache mod_rewrite
RUN a2enmod rewrite

# Copia los archivos de la aplicación Laravel al contenedor
COPY --chown=www-data:www-data . /var/www/html
#RUN chown -R www-data:www-data /var/www
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && npm install

# Establece el directorio de trabajo en la carpeta de la aplicación Laravel
WORKDIR /var/www/html

# Instala las extensiones de PHP necesarias para Laravel
RUN docker-php-ext-install pdo pdo_mysql


# Instala Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala las dependencias de PHP de tu proyecto Laravel
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY ./composer.json /var/www/html/composer.json
COPY ./composer.lock /var/www/html/composer.lock
RUN apt-get update && apt-get install -y \
    zip \
    unzip
COPY ./apache-config.conf /etc/apache2/sites-available/000-default.conf




RUN composer install --no-scripts
#RUN php artisan make:model estudiantes2 -m   
#RUN php artisan migrate 


# Expone el puerto 80 para el servidor web de Apache
EXPOSE 80

# Ejecuta Apache en primer plano
CMD ["apache2-foreground"]
