FROM composer:1.6 as depinstall

WORKDIR /build

COPY composer.json /build/

COPY database/seeds/ /build/database/seeds
COPY database/factories/ /build/database/factories

RUN composer install --no-interaction --optimize-autoloader --no-suggest --no-scripts --ignore-platform-reqs

COPY . /build/

RUN composer install --no-interaction --optimize-autoloader --no-suggest --ignore-platform-reqs
RUN composer dump-autoload --no-interaction --optimize




FROM ubuntu:18.04 as dev_image
ARG PHPSQLDIR=/opt/sqlsrv
ENV PATH="/opt/mssql-tools/bin:${PATH}"

# Update Ubuntu Software repository
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
   apt-get -y install \
   apt-transport-https     \
   apt-utils \
   autoconf \
   curl \
   dos2unix \
   g++ \
   gcc    \
   git \
   libxml2-dev \
   locales \
   make \
   php7.2 \
   php7.2-fpm \
   php7.2-dev \
   php-sqlite3 \
   re2c \
   unixodbc-dev \
   unzip && apt-get clean

# add locale iso-8859-1
RUN sed -i 's/# en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
RUN locale-gen en_US

# set locale to utf-8
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

#install ODBC driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN cat /etc/apt/sources.list.d/mssql-release.list

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools php7.2-mysql php7.2-pgsql

#Either Install git / download zip (One can see other strategies : https://ryanfb.github.io/etc/2015/07/29/git_strategies_for_docker.html )
#One option is to get source from zip file of repository.
#another option is to copy source to build directory on image
RUN mkdir -p $PHPSQLDIR
COPY ./sqlsrv_source/ $PHPSQLDIR/source
WORKDIR $PHPSQLDIR/source/

RUN dos2unix ./packagize.sh
RUN chmod +x ./packagize.sh
RUN /bin/bash -c "./packagize.sh"
RUN echo "extension = pdo_sqlsrv.so" >> /etc/php/7.2/cli/conf.d/20-pdo_sqlsrv.ini
RUN echo "extension = sqlsrv.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
RUN apt-get update && apt-get -y install php-curl

WORKDIR $PHPSQLDIR/source/sqlsrv
RUN phpize && ./configure LDFLAGS="-lgcov" CXXFLAGS="-O0 --coverage" && make && make install

WORKDIR $PHPSQLDIR/source/pdo_sqlsrv
RUN phpize && ./configure LDFLAGS="-lgcov" CXXFLAGS="-O0 --coverage" && make && make install


WORKDIR /app
COPY . /app
COPY --from=depinstall  /build/vendor /app/vendor
RUN chmod +x scheduler.sh

RUN php artisan vendor:publish --provider="Laravel\Horizon\HorizonServiceProvider"

# Fix wanneer er een route is!
# RUN php artisan route:cache -v
ENTRYPOINT ["php", "artisan"]

EXPOSE 80
CMD ["serve", "--host=0.0.0.0", "--port=80"]
ENV APP_DEBUG=false



FROM php:7.2-fpm AS production_image

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
   apt-get -y install \
   apt-transport-https     \
   apt-utils \
   curl \
   gnupg \
   libxml2 \
   locales \
   unixodbc \
   && apt-get clean \
   && nice -n10 docker-php-ext-install -j$(nproc) pcntl

# add locale iso-8859-1
RUN sed -i 's/# en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
RUN locale-gen en_US

# set locale to utf-8
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

#install ODBC driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN cat /etc/apt/sources.list.d/mssql-release.list
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools

COPY docker/start.sh /start.sh
RUN chmod 755 /start.sh
ENTRYPOINT ["/start.sh"]

RUN mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20170718/
COPY --from=dev_image /usr/lib/php/20170718/pdo_sqlsrv.so /usr/lib/php/20170718/sqlsrv.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i -e '/^;cgi\.fix_pathinfo/ccgi.fix_pathinfo=0' /usr/local/etc/php/php.ini
RUN sed -i -e '/^;security.limit_extensions/csecurity.limit_extensions =' /usr/local/etc/php-fpm.d/www.conf
#RUN grep -R -F 'security.limit_extensions' /usr/local
RUN echo "extension = pdo_sqlsrv.so" >> /usr/local/etc/php/conf.d/20-pdo_sqlsrv.ini
RUN echo "extension = sqlsrv.so" >>     /usr/local/etc/php/php.ini


WORKDIR /var/www/html
COPY --from=dev_image --chown=www-data:www-data /app/ /var/www/html/
# run as www-data to prevent us running as root
USER www-data
