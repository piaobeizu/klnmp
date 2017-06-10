#!/bin/bash
start_all(){
        out_put "start php..."
        cd /klnmp/php-7.1.4
        /etc/init.d/php-fpm -y ./etc/php-fpm.conf

        out_put "start mariadb..."
        cd /klnmp/mariadb-10.1.22
        /etc/init.d/mysqld start --user=root

        out_put "start nginx..."
        cd /klnmp/nginx-1.12.0
        ./sbin/nginx -c ./conf/nginx.conf
}
stop_all(){
        /etc/init.d/mysqld stop
        sudo killall php-fpm
        killall nginx
}
out_put(){
        echo $1
}
Usage(){
        out_put "start: 启动php,mariadb,nginx"
        out_put "stop: 停止php,mariadb,nginx"
        out_put "reload: 重启php,mariadb,nginx"
        out_put "help: 帮助信息"
}
if [[ $# == 0 ]]; then
    out_put "start all development components..."
    start_all
else
        for args in $@
                do
                        if [[ $args == "start" ]];then
                                start_all

                        elif [[ $args == "stop" ]]; then
                                stop_all

                        elif [[ $args == "reload" ]]; then
                                stop_all
                                start_all
                                
                        elif [[ $args == "help" ]]; then
                                Usage

                        else
                                out_put $args" 参数出错"
                        fi
                done
fi
