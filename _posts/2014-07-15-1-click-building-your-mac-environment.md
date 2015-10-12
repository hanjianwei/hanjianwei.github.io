---
title: "一袋烟功夫构建Mac环境"
tags: devops
---

最近硬盘不幸挂掉，换了新硬盘后重装系统、搭建环境真是一个痛苦的过程。尤其是后者，各种软件的配置、开发环境的设定，非常繁琐。这里索性总结一下，怎么能够将开发、应用的环境配置系统化，使得更换系统时能够迅速重建原来的环境。这里虽然是针对Mac来说的，对于Linux应该也类似。

作为一个开发者用户，我关心的数据主要有以下几类：

1. 代码
2. 各种资料、数据（照片、视频、文档、程序数据等）
3. 应用程序及其配置信息
4. 系统配置信息

对于代码而言，如果是开源的，放在GitHub是最好的方案；如果是内部代码，可以考虑用[GitLab](https://about.gitlab.com)搭建一个私有服务器来存放代码，当然也可以放在Dropbox之类的网盘上。对于资料文档以及比较大的数据，可以放在网盘上。无论是代码还是文档，除了网上存储之外，最好能定期备份到移动硬盘上，一来是防止网盘出问题，二来是大数据从网盘下载较慢，如果急用就比较痛苦了。所以这里我们主要侧重于后面两点：应用程序的安装配置及系统的配置。

### 使用Homebrew管理程序

Mac中的App主要有两类：一类是从App Store中安装的；另一类是下载安装的。对于前者，没有什么太好的办法，到Purchased里面一个个重新装过就好了；对于后者，用[Homebrew](http://brew.sh)来管理更加方便，相比直接的下载安装而言，它是更容易自动化、更易重现的方式。

对于dmg和pkg程序，可以用[Homebrew Cask](http://caskroom.io)来安装。

如果要装的程序没有在Homebrew或者Cask里面，可以在你的GitHub中[建立一个Repo](https://github.com/hanjianwei/homebrew-apps)来存放相关的Formula/Cask，然后用[brew tap](https://github.com/Homebrew/homebrew/wiki/brew-tap)将其加到Homebrew中。

Homebrew的好处是，你很容易将当前安装的程序列表[备份](http://www.topbug.net/blog/2013/12/07/back-up-homebrew-packages/)起来以备下次安装。另外一种备份方法是采用[Brewfile](https://coderwall.com/p/afmnbq)，不过Homebrew[已经后悔把这东西加进去了](https://github.com/Homebrew/homebrew/pull/30749)，以后也许会有更好的方案出现吧。

### 管理配置文件

安装程序其实只是最简单的一步，更麻烦的是如何对这些程序进行配置。当前一个很流行的方式是把你的配置文件放在一个[Dotfiles](http://dotfiles.github.io)的[Repo](https://github.com/hanjianwei/dotfiles)里，然后将其符号链接到相应的位置。然后你就可以用Git轻松管理你的配置文件了。对于包含敏感信息无法放在GitHub中的信息，也可以放在Dropbox中。

把所有程序的配置文件都搜集起来当然是一件非常繁琐的事情，而[Mackup](https://github.com/lra/mackup)可以把你从这件事情里面解放出来，它记录了很多程序的配置文件，从而能够自动在系统中搜索这些配置文件，备份到你的目录中，然后再符号链接到相应的位置。结合GitHub或者Dropbox来进行备份，真是太方便了！

Dotfiles中还可以保存一些常用的脚本，比如[mathiasbynens的dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)中就包含了很多OSX的设置脚本，一键运行完成你大部分的系统设置。

然而，单靠配置文件有时候也不能完全解决问题，比如安装vim的时候，希望不但能保留.vimrc之类的配置文件，还希望能把所有的插件装上去。这时候就需要介绍下面一个系统了：Boxen。

### 用Boxen自动化环境设置

[Boxen](https://boxen.github.com)是GitHub的自动化部署工具，它能够快速为新员工构建一个开发环境。Boxen基于[Puppet](https://puppetlabs.com)，它针对Mac系统做了一系列的设置，使得环境配置更加方便快捷。关于Boxen的介绍可以看看[Gary Larizza的这篇博客](http://garylarizza.com/blog/2013/02/15/puppet-plus-github-equals-laptop-love/).

GitHub提供了一个Boxen工程的模板，叫做[our-boxen](https://github.com/boxen/our-boxen)，只要将其fork并安装[说明文档](https://github.com/boxen/our-boxen#getting-started)安装即可。安装完的our-boxen包含了一个基本的开发环境（Ruby、node等），你可以在此基础上加入你自己的东西。一般来说，你可以在modules目录里面添加相关的内容：people添加和用户相关的内容，projects中添加工程相关的内容。我的个人设置在[这里](https://github.com/hanjianwei/my-boxen/tree/master/modules/people/manifests)。

对系统默认参数的一些配置（比如全局的Ruby版本）可以通过Hiera实现，具体参考[相关说明](https://github.com/hanjianwei/my-boxen/blob/master/hiera/common.yaml.example)。你可以针对用户进行一些设置，[这里](https://github.com/hanjianwei/my-boxen/blob/master/hiera/users/hanjianwei.yaml)是我的个人设置。

你甚至可以把[代码的Repo](https://github.com/hanjianwei/my-boxen/blob/master/modules/people/manifests/hanjianwei/repositories.pp)和[系统相关的配置](https://github.com/hanjianwei/my-boxen/blob/master/modules/people/manifests/hanjianwei/osx.pp)写在文件里，下次部署时直接搞定。

Boxen支持Homebrew/Cask，所以我们上面[安装的App可以直接写文件中](https://github.com/hanjianwei/my-boxen/blob/master/modules/people/manifests/hanjianwei/applications.pp)，下次部署时只要一个`boxen`命令即可。Boxen自身也只是App的安装，其[GitHub帐户](https://github.com/boxen)中包含了很多可用的App，和Homebrew/Cask相比，这些App的更新可能相对较慢，但一般会提供更多的配置选项。对于简单的的应用，我一般使用Homebrew/Cask来管理，对于配置比较复杂的（如Ruby）我会采用Boxen提供的版本。

此外，我写了一个puppet的模块[puppet-dotfiles](https://github.com/hanjianwei/puppet-dotfiles)，可以使用Mackup兼容的配置文件，直接在Boxen工程中进行配置，使得程序的配置更加自动化。该模块除了用Mackup的配置文件，还会进行了一些其它的设置，比如安装vim的时候会安装上[Vundle](https://github.com/gmarik/Vundle.vim)及其它插件、自动安装[prezto](https://github.com/sorin-ionescu/prezto)及其模块等。

Boxen的另外一个好处是删除简单，只要把`/opt/boxen`删除即可（当然可能你还要删除`/opt`下的`homebrew-cask`之类的）。

### 缓存安装文件

虽然上述过程能够大大减轻你的负担，但是在恶劣的网络环境中，下载安装文件就会成为一个瓶颈。我的解决方案是：缓存安装文件。

Homebrew/Cask安装程序时会把安装文件缓存下来，下次重装的时候就不会再次下载了。我的Mac是11年的型号，光驱位换了SSD，所以就把这些缓存文件备份到原来的硬盘：

{% highlight bash %}
$ mv `brew --cache` "/Volumes/Macintosh HD/"
$ ln -s "/Volumes/Macintosh HD/cache" `brew --cache`
{% endhighlight %}

这样万一SSD坏掉，重装起来也会比较快一点。

当然，编译也是一项非常耗时的任务，这个问题主要存在Homebrew中（因为Cask只是些dmg、pkg）。不过Homebrew非常佛心地提供了编译好的二进制版本（叫做[Bottle](https://github.com/Homebrew/homebrew/wiki/Bottles#bottle-creation)），只要你用默认选项安装，就会使用二进制版本，免去你的编译之苦。然而，不幸的是，某些程序的编译过程需要具体的路径信息（比如Qt），Homebrew默认是安装在`/usr/local`的，而Boxen把Homebrew安装在了`/opt/boxen/homebrew`中，所以就[不能享受到这项好处了](https://github.com/boxen/puppet-homebrew/issues/8)，希望将来能够有所改进吧！

### 其它方案

对于这样一个常见问题，肯定是有很多方案的，这里有一些供参考的其它方案：

- [osxc](http://osxc.github.io): 基于[Ansible](http://osxc.github.io)的一套方案。
- [battleschool](https://github.com/spencergibb/battleschool): 也是基于Ansible的方案。
- [kitchenplan](https://github.com/kitchenplan/kitchenplan): 基于[Chef](http://www.getchef.com)的方案。
- [thoughtbot/laptop](https://github.com/thoughtbot/laptop): 用于Mac和Linux安装配置的一套脚本。

其实还有很多……[说说你的方案吧](https://github.com/hanjianwei/feedback/issues/new)。
