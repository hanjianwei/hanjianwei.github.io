---
layout: post
title: "DocPad: static site generator using CoffeeScript"
date: 2013-01-06 21:40
tags:
- Web
---

[DocPad][]是一个静态网站生成器，同[Jekyll][]、[Octopress][]相比，它的可定制性更强；
由于是用[CoffeeScript][]写的，速度也比以上两个快很多. 最近两天把玩了一下，感觉很不错，功能很强大，虽然有些插件不太稳定，但基本功能已经比较完备了。

我用到的几个插件:

- [marked][] + [highlight.js][]: Markdown 支持. highlight.js是基于javascript的代码高亮工具, 同pygments相比, 它功能相对简单, 但好在能和marked配合的比较好. docpad自己也有代码高亮插件, 支持pygments, 但是问题很多. 下面是highlight的配置, 写到docpad.coffee中即可:

    ``` coffeescript
    docpadConfig = {
      # Other configuration comes here
      plugins:
        marked:
          markedOptions:
            pedantic: false
            gfm: true
            sanitize: false

            highlight: (code, lang) ->
              aliases =
                html: 'xml'
              lang = aliases[lang] if aliases[lang]

              hljs = require('highlight.js')
              hljs.highlight(lang, code).value
    }
    ```

- [jade][]: Jade模板支持.
- [paged][]: 分页插件，和[partials][]有[冲突][partials-conflict], 用的时候要小心点.
- [livereload][]: 更新代码后自动刷新浏览器，酷吧:)

Docpad的功能非常强大，更多的功能可以去官网看看.

[docpad]: http://docpad.org
[jekyll]: https://github.com/mojombo/jekyll
[octopress]: http://octopress.org
[coffeescript]: http://coffeescript.org
[marked]: https://github.com/docpad/docpad-plugin-marked
[highlight.js]: https://github.com/isagalaev/highlight.js
[jade]: https://github.com/docpad/docpad-plugin-jade
[coffee-plugin]: https://github.com/docpad/docpad-plugin-jade
[paged]: https://github.com/docpad/docpad-plugin-paged
[partials]: https://github.com/docpad/docpad-plugin-partials
[livereload]: https://github.com/docpad/docpad-plugin-livereload
[partials-conflict]: https://github.com/bevry/docpad/issues/116#issuecomment-11916419