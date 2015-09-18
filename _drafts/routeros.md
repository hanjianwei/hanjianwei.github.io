


创建Metarouter

~~~ bash
[admin@MikroTik] /metarouter> import-image file-name=openwrt-mr-mips-rootfs.tgz
 imported: 100%
[admin@MikroTik] /metarouter> print
Flags: X - disabled
#   NAME      MEMORY-SIZE DISK-SIZE     USED-DISK     STATE
0   mr1       24MiB       unlimited     7383kiB       running
~~~

添加接口

~~~ bash
[admin@MikroTik] /metarouter> interface add virtual-machine=mr1 type=dynamic
[admin@MikroTik] > /interface print
 Flags: D - dynamic, X - disabled, R - running, S - slave
 #     NAME                                              TYPE             MTU
 8  R  ether9                                            ether            1500
 9  R  test                                              bridge           1500
10 DR  vif1                                              vif              1500
~~~

连接到虚拟机

~~~ bash
/metarouter console 0
~~~
