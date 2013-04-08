---
title: Ruby on Rails
layout: page
---

## Rails的设计思想

Rails的哲学和Python有异曲同工之处, 即:

> There is a “best” way to do things, and it’s designed to encourage that way – and in some cases to discourage alternatives.

而Python的哲学正是:

> There should be one—and preferably only one—obvious way to do it.

与之相对的是Perl, 它的哲学是:

> There is more than one way to do it．

Rails最主要的三大原则:

* **D**on't **R**epeat **Y**ourself.
* **C**onvention **o**ver **C**onfiguration.
* **REST** is the best pattern for web applications.

这其中很重要的一个原则就是CoC, 即"约定优于配置". Rails习惯用约定来把各个部分关联起来, 从而避免过多的配置. 比如数据库中的一个表`orders`, 它对应的模型就是`Order`, 对应的文件就是`/app/models/order.rb`, 主键就是`id`, 依此类推. [这里](http://itsignals.cascadia.com.au/?p=7/)给出了一些比较基本的约定.


## MVC


Rails的核心是MVC架构(Model, View, Controller)

* **Model**: 数据及操作数据的规则, Rails里面主要用来管理数据库的表
* **View**: 用户界面, Rails中主要用HTML文件及其内嵌的Ruby代码来对数据进行表示
* **Controller**: 连接Model和View的胶水, Rails中主要接受用户请求, 然后从Model中获取数据, 最后把数据传给View进行显示

## 资料

### 教程

1. [Rails Guide](http://guides.rubyonrails.org/getting_started.html): 官方教程, 如果只看一个文档就看这个.
2. [Rails之道](http://book.douban.com/subject/4727011/): 这本书写的还是不错的, 除了教你基本的步骤之外会给你讲一下内部是怎么处理的.
3. [Web开发敏捷之道——应用Rails进行敏捷Web开发](http://book.douban.com/subject/4888652/): 这本书是Rails开发的经典之作了, 不过对我来说还是上面那本比较好一点.

### 风格指导

* 风格指导: [Rails Style Guide](http://stylesror.github.com/).

## Tips

* `public/`是网站的公开目录, 可用于存放css, js等静态文件. 注意该目录是可以公开访问的, 不要把重要数据等不宜公开的数据放到这里.
* `rails c`可以在console中调试程序, 而`rails c -sandbox`可以不改变数据库.

## Gems

### UI

* [Simple Form](https://github.com/plataformatec/simple_form/)
* [Twitter Bootstrap for Rails](https://github.com/seyhunak/twitter-bootstrap-rails)

### Uploading

* [CarrierWave](https://github.com/jnicklas/carrierwave)

### Authentication

* [Sorcery](https://github.com/NoamB/sorcery)
