# https://github.com/liujin0506/alpine-php7

FROM alpine:edge

MAINTAINER liujing <liujin0506@qq.com>

# https://pkgs.alpinelinux.org/packages

# Mirror mirror switch to Ali-OSM (Alibaba Open Source Mirror Site) - http://mirrors.aliyun.com/
RUN echo 'http://mirrors.aliyun.com/alpine/latest-stable/main' > /etc/apk/repositories \
	&& echo '@community http://mirrors.aliyun.com/alpine/latest-stable/community' >> /etc/apk/repositories \
	&& echo '@testing http://mirrors.aliyun.com/alpine/edge/testing' >> /etc/apk/repositories

# https://github.com/matriphe/docker-alpine-php/blob/master/7.0/FPM/Dockerfile
# Environments
ENV TIMEZONE            Asia/Shanghai
ENV PHP_MEMORY_LIMIT    512M
ENV MAX_UPLOAD          50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST        100M
ENV COMPOSER_ALLOW_SUPERUSER 1


# Mirror mirror switch to Alpine Linux - http://dl-4.alpinelinux.org/alpine/
RUN apk update \
	&& apk upgrade \
	&& apk add \
		vim \
		curl \
		tzdata \
		unixodbc \
		unixodbc-dev \
	    php8@community \
	    php8-dev@community \
	    php8-apcu@community \
	    php8-bcmath@community \
	    php8-xmlwriter@community \
	    php8-ctype@community \
	    php8-curl@community \
	    php8-exif@community \
	    php8-iconv@community \
	    php8-intl@community \
	    php8-json@community \
	    php8-mbstring@community\
	    php8-opcache@community \
	    php8-openssl@community \
	    php8-pcntl@community \
	    php8-pdo@community \
	    php8-mysqlnd@community \
	    php8-mysqli@community \
	    php8-pdo_mysql@community \
	    php8-pdo_odbc@community \
	    php8-phar@community \
	    php8-posix@community \
	    php8-session@community \
	    php8-xml@community \
	    php8-simplexml@community \
	    php8-mcrypt@community \
	    php8-xsl@community \
	    php8-zip@community \
	    php8-zlib@community \
	    php8-dom@community \
	    php8-redis@community\
	    php8-tokenizer@community \
	    php8-imagick@community \
	    php8-gd@community \
	    php8-fileinfo@community \
	    php8-zmq@community \
	    php8-xmlreader@community \
 	&& cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
	&& echo "${TIMEZONE}" > /etc/timezone \
	&& apk del tzdata \
 	&& rm -rf /var/cache/apk/*

# https://github.com/docker-library/php/issues/240
# https://gist.github.com/guillemcanal/be3db96d3caa315b4e2b8259cab7d07e
# https://forum.alpinelinux.org/forum/installation/php-iconv-issue

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
RUN rm -rf /var/cache/apk/*


# Set environments
RUN sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini && \
	sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && \
	sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php7/php.ini && \
	sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && \
	sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && \
	sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= 0|i" /etc/php7/php.ini

# composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer

# composer laravel mirror

RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

CMD ["/usr/bin/php", "-a"]
