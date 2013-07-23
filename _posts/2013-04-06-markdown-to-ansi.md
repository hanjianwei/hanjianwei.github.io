---
layout: post
title: "Markdown的Ansi显示"
date: 2013-04-06 21:40
tags:
    - Web
    - Ruby
---

随着Jekyll, Octopres, Docpad等一批静态博客生成器的兴起, Markdown已经成为写博客的利器. 不过有时候想把博客上的文章直接贴到BBS上还是需要去做一些转换的。

原因主要有二:

1. 直接复制网页有些链接就只有文字没有URL, 同时代码高亮之类的就没了.
2. 直接粘贴Markdown会引入一些不必要的字符(比如代码块的标记等).

看[Redcarpet](https://github.com/vmg/redcarpet)的介绍发现它支持自定义Render, 于是就写了个Markdown到Ansi的工具. 原理很简单, Redcarpet首先把Markdown解析为一系列的elements, 然后通过定义`Redcarpet::Render::Base`的子类对这些元素进行处理: 用[ansi](http://rubyworks.github.io/ansi/)来对文字进行着色, 用[pygments.rb](https://github.com/tmm1/pygments.rb)来对代码进行高亮. 基本的代码如下:

``` ruby
class Ansi < Redcarpet::Render::Base
  def normal_text(text)
    text.strip
  end

  def block_code(code, language)
    Pygments.highlight(code, :lexer => language, :formatter => 'terminal') + "\n\n"
  end

  def double_emphasis(text)
    " #{ansi(text, :yellow, :on_red)} "
  end

  # Other elements goes here
end

md = Redcarpet::Markdown.new(Ansi, :fenced_code_blocks => true)
md.render('Hello **markdown**\n')
```

写了一个简单的Gem, 欢迎[fork](https://github.com/hanjianwei/md2ansi)或使用:

``` bash
gem install md2ansi
```
