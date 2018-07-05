FROM centos:latest

MAINTAINER Steven <wangxk1991@gmail.com>

WORKDIR /root

COPY config/* /tmp/ 
COPY components/* /tmp/ 
# prepare
#yum install -y epel-release 安装扩展包，否则安装不了libmcrypt等
RUN yum install -y epel-release && yum update -y && \
    yum install -y wget vim gcc cmake make gcc-c++ openssl openssl-devel.x86_64 lsof chkconfig psmisc && \
    mkdir /klnmp /klnmp/www /klnmp/log /klnmp/log/php /klnmp/log/mariadb /klnmp/log/nginx && cp /tmp/klnmp /klnmp/klnmp && chmod +x /klnmp/klnmp && \
    groupadd www && useradd -g www www           

RUN yum install -y libevent ncurses-devel bison ncurses && \
#install mariadb-10.1.22
    mkdir /klnmp/mariadb-10.1.22 /klnmp/mariadb-10.1.22/data /klnmp/mariadb-10.1.22/etc && cd && \
    tar -zxvf /tmp/mariadb-10.1.22.tar.gz && cd mariadb-10.1.22 && \
    cmake . -DCMAKE_INSTALL_PREFIX=/klnmp/mariadb-10.1.22 \
    -DMYSQL_DATADIR=/klnmp/mariadb-10.1.22/data \
    -DSYSCONFDIR=/klnmp/mariadb-10.1.22/etc \ 
    -DMYSQL_UNIX_ADDR=/klnmp/mariadb-10.1.22/mysql.sock \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \ 
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_SPHINX_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DWITH_SSL=system \
    -DWITH_ZLIB=system \
    -DWITH_LIBWRAP=0 -DDEFAULT_CHARSET=utf8 \ 
    -DDEFAULT_COLLATION=utf8_general_ci 
    -DENABLED_LOCAL_INFILE=1 \
    -DENABLED_LOCAL_INFILE=1 
    -DENABLE_PROFILING=1 && \
    make && make install && \

    cd /klnmp/mariadb-10.1.22/scripts && ./mysql_install_db --datadir=/klnmp/mariadb-10.1.22/data/ --basedir=/klnmp/mariadb-10.1.22/ --user=root && cp ../support-files/mysql.server /etc/rc.d/init.d/mysqld && \

    cp /tmp/my.cnf /klnmp/mariadb-10.1.22/etc && \

#install php
    yum install -y  libmcrypt.x86_64 libmcrypt-devel.x86_64 mcrypt.x86_64 mhash libxml2 libxml2-devel.x86_64  curl-devel libjpeg-devel libpng-devel freetype-devel gd gd-devel m4 autoconf && cd && \

    ln -s /klnmp/mariadb-10.1.22/lib/libmysqlclient.so /usr/lib64/ && ln -s /klnmp/mariadb-10.1.22/lib/libmysqlclient.so.18 /usr/lib64/ && \
    echo -e "\n/usr/local/lib\n/usr/local/lib64\n/usr/local/related/libmcrypt/lib/\n" >> /etc/ld.so.conf.d/local.conf && ldconfig -v && \

    cd && tar zxvf /tmp/php-7.1.4.tar.gz && cd php-7.1.4 && \

#64位系统添加--with-libdir=lib64参数
    cd ~/php-7.1.4 && \
    ./configure --prefix=/klnmp/php-7.1.4 \
    --with-config-file-path=/klnmp/php-7.1.4/etc \
    --with-mysqli=/klnmp/mariadb-10.1.22/bin/mysql_config \
    --with-iconv --with-zlib \
    --with-libxml-dir=/usr \
    --enable-xml --disable-rpath \
    --enable-bcmath --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \
    --with-curl \
    --enable-mbregex \
    --enable-fpm \
    --enable-mbstring \
    --with-gd\
    --enable-gd-native-ttf \
    --with-openssl \
    --with-mhash \
    --enable-pcntl \
    --enable-sockets \
    --with-xmlrpc \
    --enable-zip \
    --enable-soap \
    --enable-opcache \
    --with-pdo-mysql \
    --enable-maintainer-zts \
    --with-mysqli=shared,mysqlnd \
    --with-pdo-mysql=shared,mysqlnd \
    --enable-ftp \
    --enable-session \
    --with-gettext \
    --with-jpeg-dir \
    --with-freetype-dir \
    --without-gdbm \
    --disable-fileinfo \
    --with-mcrypt \
    --with-iconv \
    --with-libdir=lib64 && \
    make && make install && \
# 安装pear
    /klnmp/php-7.1.4/bin/pear channel-update pear.php.net && /klnmp/php-7.1.4/bin/pear install channel://pear.php.net/PHP_Archive-0.12.0 && \

#    echo -e '\nexport PATH=/klnmp/php-7.1.4/bin:/klnmp/php-7.1.4/sbin:$PATH\n' >> /etc/profile && source /etc/profile && \

    mv /klnmp/php-7.1.4/etc/php-fpm.d/www.conf.default /klnmp/php-7.1.4/etc/php-fpm.d/www.conf.default.bak && \

    cp /tmp/php-fpm.conf /klnmp/php-7.1.4/etc/php-fpm.conf && cp /tmp/php.ini /klnmp/php-7.1.4/etc/php.ini && cp /tmp/www.conf /klnmp/php-7.1.4/etc/php-fpm.d/www.conf && \

#RUN chmod +x /etc/init.d/php-fpm && chkconfig --add php-fpm

# install nginx
    yum -y install pcre pcre-devel zlib zlib-devel && cd && tar zxvf /tmp/nginx-1.12.0.tar.gz && cd nginx-1.12.0 && \
    ./configure --prefix=/klnmp/nginx-1.12.0 \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-threads && \
    make && make install && \
    mkdir /klnmp/nginx-1.12.0/conf/vhost && mv /klnmp/nginx-1.12.0/conf/nginx.conf /klnmp/nginx-1.12.0/conf/nginx.conf.bak && \

    cp /tmp/nginx.conf /klnmp/nginx-1.12.0/conf/nginx.conf && cp /tmp/index.php /klnmp/www/index.php && \

#    echo -e "\nexport PATH=$PATH:/klnmp\n" >>/etc/profile && source /etc/profile && \
    echo -e "\nsource /etc/profile\n" >>/root/.bashrc && source /root/.bashrc && \

# remove all software
    cd && rm -rf *.tar.gz mariadb-10.1.22 nginx-1.12.0 php-7.1.4 /tmp/*

ENV PATH=$PATH:/klnmp:/klnmp/php-7.1.4/bin:/klnmp/php-7.1.4/sbin:/klnmp/mariadb-10.1.22/bin

EXPOSE 80

CMD [ "sh", "-c", "/bin/bash"]
