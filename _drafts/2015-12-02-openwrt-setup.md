---
title: 网件WNDR4300上安装配置OpenWrt
tags: nas
---

WNDR4300是网上比较推荐的支持OpenWrt的路由器：其内存和闪存都是128M，OpenWrt对其也有比较好的支持，是一个比较适合折腾的路由器。

### OpenWrt安装、配置

首先下载WNDR4300的固件，OpenWrt的[下载页面](https://downloads.openwrt.org)列出了不同版本的的固件，一般来说下载最新的release即可。
比如当前支持WNDR4300的最新固件是[Chaos Calmer 15.05](https://downloads.openwrt.org/chaos_calmer/15.05/ar71xx/nand/openwrt-15.05-ar71xx-nand-wndr4300-ubi-factory.img)。在下载的时候需要注意，如果是第一次刷机，要下载factory固件；如果以前刷过OpenWrt，下载sysupgrade。

然后，进入路由器的web界面，找到「固件升级」，选择下载的包确定。重启后，路由器的系统就变成OpenWrt了。需要注意的是，重启后默认Wifi没有开启，按一下路由器上的Wifi开关即可。在电脑上，脸上OpenWrt这个热点，浏览器打开`192.168.1.1`登录，用户名为root，没有密码。进入系统后，先进入「System → Administration」修改密码、添加SSH公钥等。

在web页面选择「Network → Interfaces」，对WAN口进行配置。然后进入「Network → Wifi」，设置SSID和Wifi密码。

## Shadowsocks

首先，在路由器上安装[shadowsocks](https://shadowsocks.org)的客户端：

{% highlight bash %}
$ opkg install http://openwrt-dist.sourceforge.net/releases/ar71xx/packages/shadowsocks-libev_2.4.1-1_ar71xx.ipk
{% endhighlight %}

安装时到shadowsock的[下载页面](http://openwrt-dist.sourceforge.net/releases/ar71xx/packages/)确定软件的具体版本。如果你空间有限，也可以装`polarssl`版本。

编辑`/etc/shadowsock.json`，填上你shadowsock服务器的信息。

然后设置shadowsock自动启动：

{% highlight bash %}
$ /etc/init.d/shadowsocks enable
$ /etc/init.d/shadowsocks start
{% endhighlight %}

你可以将自己系统的SOCKS Proxy设置为`192.168.1.1:1080`，测试下shadowsocks是否工作正常。

### 配置VPN

安装pptp的支持包：

{% highlight bash %}
$ opkg install ppp-mod-pptp
{% endhighlight %}

然后，编辑`/etc/config/network`，添加/修改下面的部分：

~~~
config 'interface' 'vpn'
        option 'ifname'    'pptp-vpn'  
        option 'proto'     'pptp'
        option 'username'  'vpnusername'
        option 'password'  'vpnpassword'
        option 'server'    'vpn.example.org or ipaddress'
        option 'buffering' '1'
~~~~

### DSN服务器设置

为了防止DNS污染，利用dnsmasq将[gfwlist](https://github.com/gfwlist/gfwlist)中的域名用8.8.8.8解析。OpenWrt自带的dnsmasq功能是有限制的，首先安装上完全版的dnsmasq:

{% highlight bash %}
$ opkg remove dnsmasq && opkg install dnsmasq-full
{% endhighlight %}
