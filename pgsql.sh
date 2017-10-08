#!/usr/bin/env bash
wget https://ftp.postgresql.org/pub/source/v9.6.4/postgresql-9.6.4.tar.gz
yum install -y perl-ExtUtils-Embed readline-devel pam-devel libxslt libxslt-devel openldap openldap-devel tcl tcl-devel
tar -zxvf postgresql-9.6.4.tar.gz
./configure --prefix=/klnmp/pgsql-9.6.4 --with-segsize=8 --with-wal-segsize=64 --with-tcl --with-libedit-preferred  --with-perl --with-python --with-pam --with-openssl --with-ldap --with-libxml --enable-profiling --with-libxslt --enable-thread-safety
make && make install
groupadd postgres && adduser -g postgres postgres && su - postgres
cd /klnmp/ && chown -R postgres.postgres pgsql-9.6.4 && chmod -R 775 pgsql-9.6.4
cd /klnmp/pgsql-9.6.4/bin && ./initdb -D /klnmp/pgsql-9.6.4/data --locale=C --encoding=UTF8
