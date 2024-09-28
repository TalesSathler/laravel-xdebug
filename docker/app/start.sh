#!/bin/bash

if ! command -v composer; then
    echo "...Installing composer in container..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    export PATH="$PATH:/usr/local/bin:/root/.config/composer/vendor/laravel/installer/bin"
fi

if ! command -v laravel; then
    echo "...Installing laravel in container..."
    composer global require laravel/installer
fi

composer install
php artisan migrate &
php artisan optimize:clear &

chmod 777 -R .

/etc/init.d/php8.3-fpm start -F -R
tail -f /var/log/php8.3-fpm.log
