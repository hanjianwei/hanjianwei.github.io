---
title: "Nix: 纯函数式包管理器"
date: 2014-09-21T20:04:00+08:00
tags: [devops]
---

[Nix](http://nixos.org/nix/)是一个Linux/Unix下的[包管理器](https://en.wikipedia.org/wiki/Package_management_system)，它支持原子升级和回滚、能够同时安装同一个包的多个版本、支持多用户，能够更加简单地搭建开发、构建环境。它最大的卖点在于 *函数式* 的管理方式：把软件包作为函数式语言的值，这些值由没有副作用的函数构建，一旦构建完就不再改变，这意味着你的软件运行环境一旦构建就不会改变——这对于可重现的开发而言非常重要。

### 安装

如果你想充分体验Nix的强大功能，可以安装[NixOS](http://nixos.org)，它是一个构建于Nix之上的Linux发型版。

如果你不想装一个新的系统，或者像我一样主要用Mac OSX工作，也可以只安装Nix。最简单的方式就是在Terminal里面执行如下命令：

~~~ bash
$ bash <(curl https://nixos.org/nix/install)
~~~~

然后把下面这段脚本加入到你的shell启动文件中(`~/.zshrc`、`~/.bashrc`等)：

~~~ bash
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh;
fi
~~~~

然后就可以查看有什么可用的包：

~~~ bash

$ nix-env -qa
~~~~

安装一个包：

~~~ bash
$ nix-env -i hello
~~~~

卸载一个包：

~~~ bash
$ nix-env -e hello
~~~~

升级所有的包：

~~~ bash
$ nix-channel --update nixpkgs
$ nix-env -u '*'
~~~~

回滚上一步操作：

~~~ bash
$ nix-env --rollback
~~~~

垃圾回收不用的包：

~~~ bash
$ nix-collect-garbage -d
~~~~

### 包管理

安装Nix时主要创建了两个目录：`/nix`和`$HOME/.nix-profile`。我们来看看安装的包到底是如何组织的，比如当前有一个包`hello`：

~~~ bash
$ which hello
/Users/hjw/.nix-profile/bin/hello
~~~~

可以看到，`hello`来自于`$HOME/.nix-profile`，而后者是一个符号链接，其指向如下：

~~~ plaintext
~/.nix-profile
     ⬇︎
/nix/var/nix/profiles/default
     ⬇︎
/nix/var/nix/profiles/default-6-link
     ⬇︎
/nix/store/hsw97dr9h9z3wmlwhx2lib8r3k2f9wv3-user-environment
~~~~

进一步查看最后一个目录（省略部分输出）：

~~~ bash
$ ls -l /nix/store/hsw97dr9h9z3wmlwhx2lib8r3k2f9wv3-user-environment
bin
etc -> /nix/store/2vk1g8qkly4aqwx6ks49mzkd5kxhrd5f-nix-1.8pre3766_809ca33/etc
include -> /nix/store/2vk1g8qkly4aqwx6ks49mzkd5kxhrd5f-nix-1.8pre3766_809ca33/include
……

$ ls -l /nix/store/hsw97dr9h9z3wmlwhx2lib8r3k2f9wv3-user-environment/bin
ccmake -> /nix/store/r5rr3h6fg9sb0vararwh3plm2v9p8hcm-cmake-2.8.12.2/bin/ccmake
cmake -> /nix/store/r5rr3h6fg9sb0vararwh3plm2v9p8hcm-cmake-2.8.12.2/bin/cmake
……
~~~~

可以发现，实际的文件都是存在`/nix/store`中的。这也是Nix管理包的方式：所有的包都存放在`/nix/store`中，而用户访问的都是指向`/nix/store`中文件的符号链接。

Profile是Nix管理包的方式，在`/nix/var/nix/profiles`中保存了当前的profile：

~~~ bash
$ ls -l /nix/var/nix/profiles
default -> default-6-link
default-5-link -> /nix/store/g7l19z0c0ka41irwkn4mz67a0z85xydg-user-environment
default-6-link -> /nix/store/hsw97dr9h9z3wmlwhx2lib8r3k2f9wv3-user-environment
per-user
~~~~

其中`default`就是当前的profile。如果我们删除一个包呢？

~~~ bash
$ nix-env -e hello
uninstalling ‘hello-2.9’
building path(s) ‘/nix/store/816saagv6v8s19b2sksbgzjj0ljf5qfk-user-environment’
created 62 symlinks in user environment

$ ls -l /nix/var/nix/profiles
default -> default-7-link
default-5-link -> /nix/store/g7l19z0c0ka41irwkn4mz67a0z85xydg-user-environment
default-6-link -> /nix/store/hsw97dr9h9z3wmlwhx2lib8r3k2f9wv3-user-environment
default-7-link -> /nix/store/816saagv6v8s19b2sksbgzjj0ljf5qfk-user-environment
per-user
~~~~

注意到删除一个包会生成一个新的profile —— `default-7-link`，而`default`也会指向新生成的profile。这也是Nix的工作方式，你删除包的时候，包其实并没有被删除，而是生成了一个不包含原来包的新profile！而你随时可以回到原来的状态。如果我们后悔删除`hello`了，那么可以回滚上述操作：

~~~ bash
$ which hello
hello not found
$ nix-env --rollback
switching from generation 7 to 6
$ which hello
/Users/hjw/.nix-profile/bin/hello
$ ls -l /nix/var/nix/profiles
default -> default-6-link
default-5-link -> /nix/store/g7l19z0c0ka41irwkn4mz67a0z85xydg-user-environment
default-6-link -> /nix/store/hsw97dr9h9z3wmlwhx2lib8r3k2f9wv3-user-environment
default-7-link -> /nix/store/816saagv6v8s19b2sksbgzjj0ljf5qfk-user-environment
per-user
~~~~

可以看到，回滚之后`default`又指向了`default-6-link`，`hello`又可以用了。Profile使用起来非常灵活，我们可以很方便地在各个profile之间切换：

~~~ bash
$ nix-env --list-generations
   5   2014-09-13 20:58:33
   6   2014-09-19 10:00:58   (current)
   7   2014-09-21 21:16:57
$ nix-env --switch-generation 7
switching from generation 6 to 7
$ nix-env --switch-profile /nix/var/nix/profiles/my-profile
$ ls -l ~/.nix-profile
/Users/hjw/.nix-profile -> /nix/var/nix/profiles/my-profile
~~~~

如果我们从来不真正删除包，毫无疑问硬盘慢慢就会被占满，Nix支持垃圾回收。我们需要首先删除不用的profile：

~~~ bash
$ nix-env --delete-generations 5
removing generation 5
$ nix-env --delete-generations old
removing generation 6
$ nix-env --list-generations
   7   2014-09-21 21:16:57   (current)
~~~~

然后，可以运行垃圾回收的命令。这里的垃圾回收跟编程语言的垃圾回收机制很像，一个包如果没有profile用到它就会被删除：

~~~ bash
$ nix-store --gc
~~~~

如果你不确定哪些东西会被删除，可以先把要删除的东西打印一下看看：

~~~ bash
$ nix-store --gc --print-dead
~~~~

还有另外一个命令，它会删除`/nix/var/nix/profiles`下所有profile的老版本，可以用来清理你的系统：

~~~ bash
$ nix-collect-garbage -d
~~~~

Nix的profile其实是可以放在任意位置的，但是垃圾回收的时候之后回收`/nix/var/nix/gcroots`下所指向的那些profile目录：

~~~ bash
$ ls -l /nix/var/nix/gcroots
auto
profiles -> /nix/var/nix/profiles
~~~~

### Channel

Nix的Channel存储了包的集合，可以通过命令添加Channel：

~~~ bash
$ nix-channel --add http://nixos.org/channels/nixpkgs-unstable
~~~~

更新Channel:

~~~ bash
$ nix-channel --update
~~~~

升级已有的包：

~~~ bash
$ nix-env -u '*'
~~~~

此外，Nix还提供了很方便的工具让你把包及其依赖导出、导入以及通过SSH拷贝到另一台机器上：

~~~ bash
$ nix-store --export $(nix-store -qR $(type -p firefox)) > firefox.closure
$ nix-store --import < firefox.closure
$ nix-copy-closure --to alice@itchy.example.org $(type -p firefox)
~~~~

### Nix表达式

Nix的包是由Nix表达式描述的，它所使用的[Nix expression language](http://nixos.org/nix/manual/#idm47361539226272)是一种支持惰性求值的纯函数式语言。下面是一个简单的`hello`包的描述：

~~~ nix
{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "hello-2.1.v1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/hello/hello-2.1.1.tar.gz;
    md5 = "70c9ccvf9fac07f762c24f2df2290784d";
  };
  inherit perl;
}
~~~~

这个描述其实就是一个函数，`{stdenv, fetchurl, perl}`是函数的参数，表示构建这个包需要什么东西，`stdenv`提供了一个标准的构建环境，`fetchurl`通过url抓取一个文件，而`perl`是Perl的解释器。`mkDerivation`是`stdenv`提供的一个函数，它通过一个属性集合来构建一个包。`mkDerivation`的参数也就是后面花括弧括起来的那部分是一个集合，描述了这个包的属性，如名字、源代码、以及所需的解释器，其中的`builder`表示构建这个包的脚本：

~~~ bash
source $stdenv/setup

PATH=$perl/bin:$PATH

tar xvfz $src
cd hello-*
./configure --prefix=$out
make 5
make install
~~~~

更具体的Nix expression这里就不赘述，有兴趣的可以查看相关文档。


### 总结

Nix是一个非常强大的包管理工具，它可以非常方便地解决包的依赖以及多版本共存的问题，对于那些没有包管理系统的语言（如C/C++）是一个比较好的选择；对于包管理很弱的语言（如Python）也能够提供一个更好的解决方法；对于涉及到多中语言的项目，能够以一种统一的方式来管理各种包，对开发者而言是一个非常好的工具。

此外，Nix所提供的包管理机制应该可以和Docker结合起来。比如本地开发的时候使用Nix，发布时将相关的包打包形成一个Docker镜像，实现[可重现的构建](http://martinfowler.com/bliki/ReproducibleBuild.html)。

如果说Nix的缺点，那就是相比`apt`、`yum`、`pacman`、`homebrew`之类比较成熟的包管理器，它包的数量还比较少，特别是在Mac上，有很多包还是处于`broken`的状态。不过Nix的开发比较活跃，即使你现在还没有用它，也值得去关注一下。

最后说一句，Nix其实也[不是真的纯函数式](http://nixos.org/wiki/Nix_impurities) :-)
