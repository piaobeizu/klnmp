klnmp
===

[![lnmp][]]

简单的lnmp集成环境一键生成工具


使用手册
---
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

安装成功后，请执行命令：
```$xslt
klnmp start|stop|restart
```
如果报klnmp命令不存在，就先执行如下命令：
```$xslt
source /etc/profile
```