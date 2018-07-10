FROM phusion/baseimage:0.9.19

ENV DEBIAN_FRONTEND noninteractive
ENV XDEBUG_VERSION xdebug-2.6.0.tgz
ENV APCU_REPO https://github.com/krakjoe/apcu

RUN \
  echo "deb http://mirror.optus.net/ubuntu xenial main universe" > /etc/apt/sources.list && \
  echo "deb http://mirror.optus.net/ubuntu xenial-security main restricted" >> /etc/apt/sources.list && \
  echo "deb http://mirror.optus.net/ubuntu xenial-updates main restricted" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get upgrade -y && \
  rm -f /etc/service/sshd/down && \
  locale-gen en_US.UTF-8 && \
  dpkg-reconfigure locales && \
  export LANG=en_US.UTF-8 && \
  apt-get install -yq wget curl python htop git locate zip unzip telnet zsh python-software-properties software-properties-common build-essential libpcre3-dev ant

RUN \
  curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
  apt-get install -yq nodejs

RUN \
  LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
  add-apt-repository -y ppa:brightbox/ruby-ng && \
  apt-get update && \
  apt-get install -y php7.2


Run \
  apt-get install php7.0-fpm php7.0-mysql php7.0-pgsql php7.0-sqlite php7.0-curl php7.0-gd php7.0-gmp php7.0-mcrypt php7.0-intl php7.0-dev php7.0-xsl php7.0-imap php7.0-ldap php7.0-xml php7.0-bcmath php7.0-mbstring php7.0-soap php-memcached php-pear xvfb libsqlite3-dev ruby2.2 ruby2.2-dev libxext6 xfonts-75dpi fontconfig libxrender1 xfonts-base libssh2-1-dev libssh2-1

RUN \
  echo 'Installing Xdebug' && \
  wget http://xdebug.org/files/$XDEBUG_VERSION -O xdebug.tgz && \
  tar xzf xdebug.tgz && \
  rm -f xdebug.tgz && \
  cd xdebug-*/ && \
  phpize && \
  ./configure --with-php-config=/usr/bin/php-config && \
  make && \
  export TEST_PHP_ARGS='-n' && \
  make test && \
  make install && \
  cd .. && \
  rm -Rf xdebug-*/

RUN \
  echo 'Installing APCU' && \
  git clone $APCU_REPO && \
  cd apcu && \
  phpize && \
  ./configure --with-php-config=/usr/bin/php-config && \
  make && \
  export TEST_PHP_ARGS='-n' && \
  make test && \
  make install && \
  cd .. && \
  rm -Rf apcu/

# SSH2
RUN \
  yes | pecl install ssh2-1.0

# Fix php session dir and error log
RUN \
  mkdir -p /var/lib/php/sessions && \
  chown -R www-data:www-data /var/lib/php/sessions && \
  chmod 0777 -R /var/lib/php/sessions/ && \
  mkdir -p /var/log/php/ && \
  touch /var/log/php/error.log && \
  chmod 0755 /var/log/php/error.log && \
  chown -R www-data:www-data /var/log/php/ && \
  chmod 0777 -R /var/log/php/

# Install ruby dependencies
RUN \
  ruby -v && \
  gem install --no-ri --no-rdoc mailcatcher capistrano capistrano-symfony bundler && \
  gem list

ENV HOME /root

# PHP module configs
ADD conf/mods-available/apcu.ini /etc/php/7.0/mods-available/apcu.ini
ADD conf/mods-available/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
ADD conf/mods-available/mailcatcher.ini /etc/php/7.0/mods-available/mailcatcher.ini
ADD conf/mods-available/ssh2.ini /etc/php/7.0/mods-available/ssh2.ini

RUN \
  phpdismod -s fpm -v 7.0 xdebug && \
  phpdismod -s fpm -v 7.0 mailcatcher && \
  phpdismod -s ALL -v 7.0 apcu && \
  phpenmod -s cli -v 7.0 ssh2

# Create php pid location
RUN \
    mkdir -p /run/php

# Composer + PHPUnit + Phing
RUN \
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  composer config -g github-oauth.github.com aeff6491f52163a011cba0b6b6286f5492e25ab6 && \
  wget -qq -O phpunit.phar https://phar.phpunit.de/phpunit.phar && \
  chmod +x phpunit.phar && \
  mv phpunit.phar /usr/local/bin/phpunit && \
  wget -qq -O phing.phar http://www.phing.info/get/phing-latest.phar  && \
  chmod +x phing.phar && \
  mv phing.phar /usr/local/bin/phing && \
  php -v && \
  phpunit --version && \
  phing -v

# WKHTMLTOPDF
RUN \
  apt-get -y install wkhtmltopdf && \
  wkhtmltopdf --version

RUN \
  sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini && \
  sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini && \
  sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini && \
  sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/cli/php.ini && \
  sed -i "s/short_open_tag.*=.*/short_open_tag = On/" /etc/php/7.0/fpm/php.ini && \
  sed -i "s/short_open_tag.*=.*/short_open_tag = On/" /etc/php/7.0/cli/php.ini && \
  sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf

RUN \
  apt-get clean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TERM xterm
ENV PHP_ENV production
ENV PHP_APCU_ENABLED false
ENV PHP_XDEBUG_ENABLED false
ENV PHP_MAILCATCHER_ENABLED false

# Allow su www-data
ADD conf/dot-bash-rc /home/www-data/.bashrc
RUN \
   chsh -s /bin/bash www-data && \
   groupmod -g 1000 www-data && \
   usermod -u 1000 www-data && \
   chown -vR 1000:1000 /home/www-data && \
   usermod -d /home/www-data/ www-data

# Runit/init
ADD my_init.d /etc/my_init.d
ADD runit/php /etc/service/php/run

# XDebug/ssh port
EXPOSE 9000
EXPOSE 22

VOLUME /app
WORKDIR /app

CMD ["/sbin/my_init"]
