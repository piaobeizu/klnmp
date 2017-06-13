klnmp
===

轻量级的lnmp集成环境一键生成工具


项目说明
---

* 综述：
    * 所有的组件都编译安装在了/klnmp目录下
    * 版本分别为：PHP-7.1.4；mariadb-10.1.22；ngninx-1.12.0

* 分述：
    * php：
        * php的相关配置放在/klnmp/php-7.1.4/etc；
    * mariadb：
        * mariadb的配置放在/klnmp/mariadb-10.1.22/etc
    * nginx:
        * nginx的配置放在/klnmp/nginx-1.12.0/conf
        
使用手册
---
**安装之前先查看系统当前是否有mysql相关的安装包：**
```$xslt
rpm -qa | grep mysql # 查看是否安装了mysql
rpm -qa | grep mariadb # 查看是否安装了mariadb
rpm -e --nodeps mariadb-**** #如果有的话就删除
```

klnmp集成环境拥有以下两种安装方式：

* [install脚本安装](#install脚本安装)
* [Docker安装](#Docker安装)

### install脚本安装
---

#### requires
centos7+ 64位

#### installation

下载klnmp项目：

```
git clone git@github.com:piaobeizu/klnmp.git
```

执行安装脚本：
```
cd klnmp
sh install.sh
```

### Docker安装
---

#### requires
docker 环境

#### installation

下载klnmp项目：

```
git clone git@github.com:piaobeizu/klnmp.git
```

执行安装脚本：
```
cd klnmp
docker build -t klnmp:1.0 . < Dockerfile
```

### 安装完成后：
---

安装成功后，请执行命令：
```$xslt
klnmp start|stop|restart
```
如果报klnmp命令不存在，就先执行如下命令：
```$xslt
source /etc/profile
```
