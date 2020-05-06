FROM richarvey/nginx-php-fpm:1.8.2

# 设置时区 Asia/Shanghai
RUN apk add tzdata \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" >  /etc/timezone

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.
# RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
#     ALPINE_GLIBC_PACKAGE_VERSION="2.30-r0" && \
#     ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
#     ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
#     ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
#     apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
#     echo \
#         "-----BEGIN PUBLIC KEY-----\
#         MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApZ2u1KJKUu/fW4A25y9m\
#         y70AGEa/J3Wi5ibNVGNn1gT1r0VfgeWd0pUybS4UmcHdiNzxJPgoWQhV2SSW1JYu\
#         tOqKZF5QSN6X937PTUpNBjUvLtTQ1ve1fp39uf/lEXPpFpOPL88LKnDBgbh7wkCp\
#         m2KzLVGChf83MS0ShL6G9EQIAUxLm99VpgRjwqTQ/KfzGtpke1wqws4au0Ab4qPY\
#         KXvMLSPLUp7cfulWvhmZSegr5AdhNw5KNizPqCJT8ZrGvgHypXyiFvvAH5YRtSsc\
#         Zvo9GI2e2MaZyo9/lvb+LbLEJZKEQckqRj4P26gmASrZEPStwc+yqy1ShHLA0j6m\
#         1QIDAQAB\
#         -----END PUBLIC KEY-----" | sed 's/   */\n/g' > "/etc/apk/keys/sgerrand.rsa.pub" && \
#     wget \
#         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
#         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
#         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
#     apk add --no-cache \
#         "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
#         "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
#         "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
#     \
#     rm "/etc/apk/keys/sgerrand.rsa.pub" && \
#     /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
#     echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
#     \
#     apk del glibc-i18n && \
#     \
#     rm "/root/.wget-hsts" && \
#     apk del .build-dependencies && \
#     rm \
#         "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
#         "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
#         "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

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
RUN composer config -g repos.packagist composer https://mirrors.aliyun.com/composer/ \
  && composer global require hirak/prestissimo

# 安装opcache tool
RUN curl -sO http://gordalina.github.io/cachetool/downloads/cachetool.phar \
  && chmod +x cachetool.phar \
  && mv cachetool.phar /usr/local/bin/cachetool
#   && cat >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini <<'EOF' \
# opcache.validate_timestamps=0    //生产环境中配置为0 \
# opcache.revalidate_freq=0    //检查脚本时间戳是否有更新时间 \
# opcache.memory_consumption=128    //Opcache的共享内存大小，以M为单位 \
# opcache.interned_strings_buffer=16    //用来存储临时字符串的内存大小，以M为单位 \
# opcache.max_accelerated_files=4000    //Opcache哈希表可以存储的脚本文件数量上限 \
# opcache.fast_shutdown=1         //使用快速停止续发事件 \
# EOF
