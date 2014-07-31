---
title: "阿里云服务器的Docker配置"
date: 2014-07-30 20:04
tags: devops
---

最近把程序放到[阿里云](http://www.aliyun.com)服务器上，并尝试用[Docker](https://www.docker.com)来部署。阿里云的镜像列表里面已经有了Ubuntu 14.04 64位，可以直接[安装Docker](https://docs.docker.com/installation/ubuntulinux/)。然而，由于阿里云服务器的特殊情况，需要进行配置才能用。

安装完Docker之后，发现Docker服务并没有起来，检查日志发现有这么一段：

~~~
[/var/lib/docker|3c476c9d] -job init_networkdriver() = ERR (1)
Could not find a free IP address range for interface 'docker0'. Please configure its address manually and run 'docker -b docker0'
~~~

搜了下Docker的issues，发现[这个问题](https://github.com/docker/docker/issues/362)挺多人遇到过。究其原因，要从Docker的启动过程说起，在[Docker的文档](https://docs.docker.com/articles/networking/)中有这么一段话：

> When Docker starts, it creates a virtual interface named docker0 on the host machine. It randomly chooses an address and subnet from the private range defined by RFC 1918 that are not in use on the host machine, and assigns it to docker0.

也就是说，Docker在启动时，会创建一个虚拟接口`docker0`，并为其随机选择一个未被占用的内部IP。这个`docker0`其实并非一般的网络接口，而是一个虚拟的网桥（Ethernet Bridge），其作用是为了容器（Container）和宿主（Host）机器之间的通信。每当Docker启动一个容器时，它都会创建一对对等接口（"peer" interface）。这对接口有点类似于管道，向其中的一个接口发送数据包，另外一个接口就会接收到。Docker把其中的一个接口分配给容器，作为它的`eth0`接口；然后，为另外一个接口分配一个唯一的名字比如`vethAQI2QT`，将其分配给宿主机器，并将其绑定到`docker0`这个网桥上。这样每个容器都可以和宿主机器进行通信了。

上述过程在一般的环境中可能没什么问题，但在阿里云特殊的环境中可能就有问题了：Docker每次启动时都不能找到空闲的内部IP（阿里云为每台主机只分配一个内部IP），所以直接报错了。要解决该问题，有好几种方法：

### 删除内网网卡信息。

这也是[阿里云官方论坛给出的方法](http://bbs.aliyun.com/read/152090.html)。

~~~ bash
$ sudo ifconfig eth0 down
~~~

这个方法的缺点是，你就无法访问内网了，而阿里云的内部流量是不收费的（用mirrors.aliyuncs.com来升级不占用公网流量），这点还是比较可惜的。

### 自己创建网桥`docker0`，将其绑定到`eth0`。

~~~ bash
$ sudo apt-get install bridge-utils
$ sudo brctl addbr docker0
$ sudo brctl addif docker0 eth0
$ sudo ip link set dev docker0 up
$ sudo ifconfig docker0 <your-private-ip>
~~~

### 为Docker设置启动参数，指定`docker0`的IP

~~~ bash
$ sudo docker -d --bip=<your-private-ip>
~~~

要注意的是，其中的IP设置要使用标准的CIDR表示，如`10.171.211.13/21`。 在Ubuntu上，可以通过`/etc/default/docker.io`文件中的`DOCKER_OPTS`设置该选项。个人更倾向于这种方法，方便快捷。

上面的命令只是临时改变运行参数，要永久改变请查询相关手册。
