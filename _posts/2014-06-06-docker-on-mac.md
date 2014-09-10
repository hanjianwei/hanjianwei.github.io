---
title: "Docker on Mac"
tags: devops
---

在虚拟化领域，[Docker][]是一颗冉冉升起的新星。它构建于[LXC][]之上，比传统的虚拟机技术相比，它没有操作系统层，因此更加轻量化，灵活性和可移植性也更好。

Docker有两个主要的部件：daemon和作为客户端的二进制程序「docker」。docker作为客户端，把相应指令发送给daemon来执行。因为Docker使用了Linux内核的一些特性，因此只能运行在具体比较新内核的64位Linux上，其它平台上必须借助虚拟机才能运行。

在Mac上，主要有两种基于VirtualBox的运行方式：第一种是借助[boot2docker][]；第二种是使用[Vagrant][]来管理虚拟机。

boot2docker使用了一个非常轻量的Linux发行版[CoreOS][]来作为Docker的运行环境，启动很快、占用空间很少。通过[Homebrew][]来安装非常方便：

~~~ bash
$ brew install boot2docker docker
~~~

boot2docker的一个问题是和Mac之间共享文件非常不方便，官方给出的方案是[用Samba来共享文件][boot2docker-sharing]。

我更喜欢的一种方式是用Vagrant来管理Docker。Vagrant是一个管理虚拟机的软件，1.6版本加入了对[Docker的支持][vagrant-docker]，可以在Vagrant中对Docker进行管理。Vagrant可以把[Docker作为Provider][vagrant-docker-provider]，在Vagrantfile配置Docker相关的操作。一个简单的Vagrantfile的例子：

~~~ ruby
Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.image = "ubuntu:14.04"
  end
end
~~~

这个配置文件表示，启动Docker的时候使用`ubuntu:14.04`这个image。然后，执行操作：

~~~ bash
$ vagrant up --provider=docker
~~~

在非Linux系统上，Docker是需要运行在虚拟机中的。如果没有配置虚拟机（比如上述例子），Vagrant会自动使用[boot2docker][vagrant-boot2docker]作为虚拟机。当然，你可以指定一个已有的Vagrantfile作为Docker的运行主机：

~~~ ruby
Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.vagrant_vagrantfile = "../path/to/Vagrantfile"
  end
end
~~~

同直接使用boot2docker相比，Vagrant提供了非常便捷的手段处理Mac和虚拟机之间的交互，如[文件夹同步][vagrant-synced-folder]、[端口映射][vagrant-network]等。在进行文件夹同步时，Vagrant会尝试使用最佳方式进行同步，比如对boot2docker会使用rsync进行同步。

boot2docker虽然比较精简，但是功能毕竟有限，我使用了一个Ubuntu 14.04来作为Docker的运行主机，相应的Vagrantfile如下：

~~~ ruby
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Box
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.box_check_update = false

  # Provisioners
  config.vm.provision "shell", path: "apt.sh"
  config.vm.provision "docker"
  config.vm.provision "shell", path: "docker.sh"

  config.vm.network "forwarded_port", guest: 4243, host: 4243
end
~~~

注意中间的[Provisioner部分][vagrant-provisioners]，Vagrant的Provisioner的主要作用是自动安装一些软件、执行一些任务。上面的`apt.sh`是一个脚本，用来修改Ubuntu的apt源；`docker.sh`用来修改Docker的配置参数。值得注意的是，Vagrant还提供了[Docker的Provisoner][docker-provisioner]，用来安装、配置Docker。当你运行的虚拟机中没有安装Docker时，它会自动帮你安装最新的Docker。

在最后一行，我设置了一个端口映射，将虚拟机的Docker daemon的端口4243映射到本地，这样就可以使用Mac中Homebrew所带的docker客户端来执行相应的操作了（要注意Mac客户端的版本需和虚拟机中Docker daemon的版本一致）。

我们只要运行`vagrant up`，Docker的运行环境就搭建好了。Vagrant中有很多对Docker的支持，使得我们能够更方便地自动化搭建开发、部署环境，具体可以参考[Vagrant][vagrant-docs]和[Docker][docker-docs]的文档。


[Docker]: https://www.docker.io
[LXC]: http://en.wikipedia.org/wiki/Lxc
[boot2docker]: https://github.com/boot2docker/boot2docker
[Vagrant]: http://www.vagrantup.com
[CoreOS]: https://coreos.com
[Homebrew]: http://brew.sh
[boot2docker-sharing]: https://github.com/boot2docker/boot2docker#folder-sharing
[vagrant-docker]: http://www.vagrantup.com/blog/feature-preview-vagrant-1-6-docker-dev-environments.html
[vagrant-docker-provider]: http://docs.vagrantup.com/v2/docker/index.html
[vagrant-boot2docker]: https://github.com/mitchellh/vagrant/blob/master/plugins/providers/docker/hostmachine/Vagrantfile
[vagrant-synced-folder]: http://docs.vagrantup.com/v2/synced-folders/index.html
[vagrant-network]: http://docs.vagrantup.com/v2/networking/forwarded_ports.html
[vagrant-provisioners]: http://docs.vagrantup.com/v2/provisioning/index.html
[docker-provisioner]: http://docs.vagrantup.com/v2/provisioning/docker.html
[vagrant-docs]: http://docs.vagrantup.com/v2/
[docker-docs]: http://docs.docker.io
