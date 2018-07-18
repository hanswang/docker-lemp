#!/bin/bash

echo "================================"
echo "PHP ENV: ${PHP_ENV}"
echo "================================"
echo " "

if [ $PHP_ENV = "production" ] || [ $PHP_ENV = "Production" ] ; then
    echo "==> Enabling production"
    phpdismod -s ALL -v 7.2 development
    phpenmod -s ALL -v 7.2 production
else
    echo "==> Enabling development"
    phpdismod -s ALL -v 7.2 production
    phpenmod -s ALL -v 7.2 development
fi;

echo "================================"
echo "==> Reloading PHP7-FPM"
echo "================================"
service php7.2-fpm reload

echo "================================"
