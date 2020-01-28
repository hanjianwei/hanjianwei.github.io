---
title: "阿里云服务器的Docker配置"
date: 2014-07-30T20:04:00+08:00
tags: [devops]
---

最近把程序放到[阿里云](http://www.aliyun.com)服务器上，并尝试用[Docker](https://www.docker.com)来部署。阿里云的镜像列表里面已经有了Ubuntu 14.04 64位，可以直接[安装Docker](https://docs.docker.com/installation/ubuntulinux/)。然而，由于阿里云服务器的特殊情况，需要进行配置才能用。

安装完Docker之后，发现Docker服务并没有起来，检查日志发现有这么一段：

~~~ plaintext
[/var/lib/docker|3c476c9d] -job init_networkdriver() = ERR (1)
Could not find a free IP address range for interface 'docker0'. Please configure its address manually and run 'docker -b docker0'
~~~~

搜了下Docker的issues，发现[这个问题](https://github.com/docker/docker/issues/362)挺多人遇到过。究其原因，要从Docker的启动过程说起，在[Docker的文档](https://docs.docker.com/articles/networking/)中有这么一段话：

> When Docker starts, it creates a virtual interface named docker0 on the host machine. It randomly chooses an address and subnet from the private range defined by RFC 1918 that are not in use on the host machine, and assigns it to docker0.

也就是说，Docker在启动时，会创建一个虚拟接口`docker0`，并为其选择一个没有在宿主机器上使用的地址和子网。这个`docker0`其实并非一般的网络接口，而是一个虚拟的网桥（Ethernet Bridge），其作用是为了容器（Container）和宿主（Host）机器之间的通信。每当Docker启动一个容器时，它都会创建一对对等接口（"peer" interface）。这对接口有点类似于管道，向其中的一个接口发送数据包，另外一个接口就会接收到。Docker把其中的一个接口分配给容器，作为它的`eth0`接口；然后，为另外一个接口分配一个唯一的名字比如`vethAQI2QT`，将其分配给宿主机器，并将其绑定到`docker0`这个网桥上。这样每个容器都可以和宿主机器进行通信了。

那么，在阿里云中为什么会启动失败呢？在[Docker的源代码](https://github.com/docker/docker)搜索上述错误信息，可以看出问题出在[createBridge](https://github.com/docker/docker/blob/4398108433121ce2ac9942e607da20fa1680871a/daemon/networkdriver/bridge/driver.go#L246)这个函数中。该函数会检查[下列IP段](https://github.com/docker/docker/blob/503d124677f5a0221e1bf8c8ed7320a15c5e01db/daemon/networkdriver/bridge/driver.go#L53-L70):

~~~ go
var addrs = []string{
    "172.17.42.1/16",
    "10.0.42.1/16",
    "10.1.42.1/16",
    "10.42.42.1/16",
    "172.16.42.1/24",
    "172.16.43.1/24",
    "172.16.44.1/24",
    "10.0.42.1/24",
    "10.0.43.1/24",
    "192.168.42.1/24",
    "192.168.43.1/24",
    "192.168.44.1/24",
}
~~~~

对于每个IP段，Docker会检查它是否和当前机器的域名服务器或路由表有重叠，如果有的话，就放弃该IP段。让我们看看阿里云服务器的路由表：

~~~ bash
$ route -n
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         121.40.83.247   0.0.0.0         UG    0      0        0 eth1
10.0.0.0        10.171.223.247  255.0.0.0       UG    0      0        0 eth0
10.171.216.0    0.0.0.0         255.255.248.0   U     0      0        0 eth0
121.40.80.0     0.0.0.0         255.255.252.0   U     0      0        0 eth1
172.16.0.0      10.171.223.247  255.240.0.0     UG    0      0        0 eth0
192.168.0.0     10.171.223.247  255.255.0.0     UG    0      0        0 eth0
~~~~

检查一下路由表会发现，Docker所检查的IP段在路由表中都有了，所以不能找到一个有效的IP段。

解决方法其实也很简单，简单粗暴的方法就是把内网的网卡信息直接删掉，它在路由表中所对应的信息也没有了:

~~~ bash
$ sudo ifconfig eth0 down
~~~~

这种方法的缺点也很明显：你就无法访问内网了，而阿里云的内部流量是不收费的（用mirrors.aliyuncs.com来升级不占用公网流量），这点还是比较可惜的。

另一种方法是把路由表中不用的项删除，这样Docker就能找到能用的IP段了：

~~~ bash
$ sudo route del -net 172.16.0.0/12
$ sudo service docker start
$ ifconfig docker0
docker0   Link encap:Ethernet  HWaddr 56:84:7a:fe:97:99
          inet addr:172.17.42.1  Bcast:0.0.0.0  Mask:255.255.0.0
~~~~

重新启动服务，可以看到`docker0`已经建立成功，所用的IP地址就是我们删除路由表项之后腾出来的IP地址。采用这种方法，我们仍然可以使用内网的服务。如果要每次启动的时候设置，编辑`/etc/network/interfaces`，将`up route add -net 172.16.0.0 ....`那一行删掉即可。
