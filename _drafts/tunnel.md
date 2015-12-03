
### OpenWrt

安装sshtunnel:

{% highlight bash %}
$ opkg install sshtunnel
{% endhighlight %}

生成key：

{% highlight bash %}
$ dropbearkey -t rsa -f ~/.ssh/id_rsa
$ dropbearkey -y -f ~/.ssh/id_rsa
{% endhighlight %}


