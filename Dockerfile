FROM richarvey/nginx-php-fpm:1.8.2

#RUN apk update
#RUN apk add openldap-dev

# bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap
# interbase intl json ldap mbstring mysqli oci8 odbc opcache pcntl pdo pdo_dblib pdo_firebird pdo_mysql
# pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop
# simplexml snmp soap sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader
#xmlrpc xmlwriter xsl zend_test zip
RUN docker-php-ext-install pcntl bcmath opcache
# mcrypt
# 有的:mbstring json xml pdo_pgsql pgsql redis

# composer 镜像源
#composer config -g repos.packagist composer https://php.cnpkg.org
#composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
#并行下载支持
#composer global require hirak/prestissimo
RUN composer config -g repos.packagist composer https://php.cnpkg.org \
    && composer global require hirak/prestissimo
