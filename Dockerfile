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
# composer config -g repos.packagist composer https://php.cnpkg.org
# composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/


# 并行下载支持
# composer global require hirak/prestissimo
RUN composer config -g repos.packagist composer https://php.cnpkg.org \
  && composer global require hirak/prestissimo

# 安装opcache tool
RUN curl -sO http://gordalina.github.io/cachetool/downloads/cachetool.phar \
  && chmod +x cachetool.phar \
  && mv cachetool.phar /usr/local/bin/cachetool \
  && cat >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini << EOF \
opcache.validate_timestamps=0    //生产环境中配置为0 \
opcache.revalidate_freq=0    //检查脚本时间戳是否有更新时间 \
opcache.memory_consumption=128    //Opcache的共享内存大小，以M为单位 \
opcache.interned_strings_buffer=16    //用来存储临时字符串的内存大小，以M为单位 \
opcache.max_accelerated_files=4000    //Opcache哈希表可以存储的脚本文件数量上限 \
opcache.fast_shutdown=1         //使用快速停止续发事件 \
EOF
