---
title: "走马观花看Puppet"
date: 2014-07-14 16:18
tags: devops
---

[Puppet](http://puppetlabs.com)是目前最流行的一套[配置管理(Configuration Management，简称CM)](http://en.wikipedia.org/wiki/Configuration_management)系统。它提供了一套简洁、强大的框架，使系统管理的重用、分享更加简单，让系统配置更加自动化。在云计算时代，动辄需要配置大量主机，它的作用更加明显。

Puppet使用一种声明式的语言，和传统的脚本相比，你只需指定目标，而不必关注具体的执行细节。举个例子，比如我们要建立一个文件`/tmp/foobar.txt`，其内容为`Hello World!`，在Puppet中这么写就行了：

~~~ puppet
file { '/tmp/foobar.txt':
  ensure  => present,
  content => 'Hello World!',
}
~~~

将上述内容保存为`test.pp`（称为[manifest](http://docs.puppetlabs.com/learning/manifests.html)），然后执行`puppet apply test.pp`，就会确保存在一个文件`/tmp/foobar.txt`，其中的内容为「Hello World!」。在这个过程中，Puppet会检查我们声明的条件是否满足，如果满足就什么也不做；如果不满足就执行相应的操作以满足我们的要求，而这个过程对用户来说是完全透明的，你不用写各种脚本去执行各种检测和修改。

在Puppet中，`file`是一种`资源(resource)`。[资源](http://docs.puppetlabs.com/puppet/3.6/reference/lang_resources.html)是一个相当广的概念，用户、软件包、文件、服务甚至Git的库都是资源，用`puppet describe -l`可以查看系统中所有的资源类型。每种资源都有一个类型（如`file`），一个名字（如`/tmp/foobar.txt`）以及一系列的属性（如`ensure`、`content`等），可以通过`puppet describe <resource_type>`得到资源的具体描述。

通过资源声明就可以完成一些基本的任务，比如要配置一个ssh服务：

~~~ puppet
# /root/examples/break_ssh.pp
file { '/etc/ssh/sshd_config':
  ensure => file,
  mode   => 600,
  source => '/root/examples/sshd_config',
}

service { 'sshd':
  ensure     => running,
  enable     => true,
  subscribe  => File['/etc/ssh/sshd_config'],
}
~~~

其中声明了两个资源：一个配置文件，权限为`600`，内容从`/root/examples/sshd_config`复制；一个服务`sshd`，确保其处于运行状态。值得注意的是，上述`sshd`资源的最后一项是`subscribe`，这是什么东西呢？原来在Puppet中，执行顺序并不是按照资源的声明顺序来的，在上述例子中，就有可能`sshd`服务先启动起来，然后配置文件才生成，这种情况配置文件就不起作用了。

Puppet提供了一系列方法来[确保资源的执行顺序](http://docs.puppetlabs.com/learning/ordering.html)，上述的`subscribe`属于[metaparameter](http://docs.puppetlabs.com/learning/ordering.html#metaparameters-resource-references-and-ordering)，它表示当配置文件`/etc/ssh/sshd_config`修改后，自动重启`sshd`。其中`File['/etc/ssh/sshd_config']`是对资源的引用。除了metaparameter之外，还可以用[箭头](http://docs.puppetlabs.com/learning/ordering.html#chaining-arrows)来表示顺序，上述例子也可以这么写：

~~~ puppet
# /root/examples/break_ssh.pp
file { '/etc/ssh/sshd_config':
  ensure => file,
  mode   => 600,
  source => '/root/examples/sshd_config',
}
~>
service { 'sshd':
  ensure     => running,
  enable     => true,
}
~~~

当资源不多时，把所有东西都写到一个巨大的manifest里面还可以接受；随着你维护的东西越来越多，这种方法会让你的代码越来越难维护。Puppet提供了[class和module](http://docs.puppetlabs.com/learning/modules1.html)使得我们能够更加模块化地管理代码。

如果你像我一样从其它编程语言过来，那么很可能会被class这个关键字所迷惑：Puppet中的class不像C++或Java之类语言中的class，它只是一段有名字的代码。你可以用class把相关的代码包装起来，使其重用起来更加方便。比如上述代码可以修改为：

~~~ puppet
class ssh {
  file { '/etc/ssh/sshd_config':
    ensure => file,
    mode   => 600,
    source => '/root/examples/sshd_config',
  }
  service { 'sshd':
    ensure     => running,
    enable     => true,
    subscribe  => File['/etc/ssh/sshd_config'],
  }
}

include ssh
~~~

需要注意的是，class只是定义了一段代码，只有`include`之后才会声明其中的资源。同一个class可以`include`多次，效果和`include`一次一样。然而，即使有了class，我们的代码仍然在一个巨大的manifest里面啊！这里就要提到[module](http://docs.puppetlabs.com/learning/modules1.html#modules)了。

Module其实就是目录，它根据特定的[结构](http://docs.puppetlabs.com/learning/modules1.html#module-structure)来组织目录，并且其中的manifest符合一定的[命名规则](http://docs.puppetlabs.com/learning/modules1.html#organizing-and-referencing-manifests)。Puppet在[modulepath](http://docs.puppetlabs.com/learning/modules1.html#the-modulepath)中搜索module，如果一个类在module中出现了，那么你可以在任何其它的manifest中声明它。比如要配置一个Apache服务器，可以把apache作为一个模块，而mod、proxy、vhost的设置都可以作为其中的manifest。

Puppet中可以使用[变量](http://docs.puppetlabs.com/learning/variables.html)，变量以`$`开头。变量是有[作用域](http://docs.puppetlabs.com/puppet/latest/reference/lang_scope.html)的，子作用域可以访问父作用域的变量，但访问其它作用域的变量就要加上module和class前缀（如`$apache::params::confdir`）。此外，变量支持双引号字符串插值：`"The value is ${variable}"`。

上述例子中，ssh配置文件的模板位置是固定的。但是，实际应用中往往根据不同的情况做修改，我们不可能针对每种情况写一个class。为此，可以使用[带参数的class](http://docs.puppetlabs.com/learning/modules2.html)，上述例子可以修改为：

~~~ puppet
class ssh ($config_path = '/root/examples/ssd_config') {
  file { '/etc/ssh/sshd_config':
    ensure => file,
    mode   => 600,
    source => "${config_path}",
  }
  service { 'sshd':
    ensure     => running,
    enable     => true,
    subscribe  => File['/etc/ssh/sshd_config'],
  }
}

class { 'ssh':
  config_path => '/home/jack/ssd_config',
}
~~~

注意要使用带参数的class，就不能直接用`include ssh`（否则会使用默认参数），而是要用资源式的class声明方式，将参数作为属性传递进去，在这种情况下应该仔细组织manifest文件，不要将一个class声明两次。参数类的另外一种使用方法是通过[Hiera](http://docs.puppetlabs.com/hiera/1/puppet.html)来设置参数，这种方式能够尽量把代码和数据分开，是一种推荐的使用方式。

即使class可以设置参数，但是我们也只能设置一组参数，如果我们需要同时设置多组参数呢？比如Apache的vhost，我们希望能够设置多个vhost，比如：

~~~ puppet
apache::vhost {'users.example.com':
  port    => 80,
  docroot => '/var/www/personal',
  options => 'Indexes MultiViews',
}
apache::vhost {'projects.example.com':
  port    => 80,
  docroot => '/var/www/project',
  options => 'Indexes MultiViews',
}
~~~

这时候我们就需要define类型了，它所定义的类型和系统提供的资源类似，可以同时声明多个不同参数的资源。举个例子：

~~~ puppet
define planfile ($user = $title, $content) {
  file {"/home/${user}/.plan":
    ensure  => file,
    content => $content,
    mode    => 0644,
    owner   => $user,
    require => User[$user],
  }
}
planfile {'nick':
  content => "working on foobar"
}
planfile {'katie':
  content => "working on cookies"
}
~~~

要发挥Puppet最大的优势，必须了解[Agent/Master Puppet](http://docs.puppetlabs.com/learning/agent_master_basic.html)（为什么现在都不用Master/Slave了？看[这里](https://github.com/django/django/pull/2692) :wink:）。不过我暂时都是单机用用，就先不去了解了。

当然了，题目就叫走马观花，看这篇Blog你是不可能完全掌握Puppet的啦，感兴趣就去看看[tutorial](http://docs.puppetlabs.com/learning/)和[reference](http://docs.puppetlabs.com/puppet/latest/reference/)吧！
