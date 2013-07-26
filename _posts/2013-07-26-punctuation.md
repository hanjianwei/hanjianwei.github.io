---
layout: post
title: "标点符号的用法"
date: 2013-07-26 10:33
tags:
    - Writing
---

虽然每天都要用到标点符号，但从来没有去注意过其中的细节。今天翻看自己写过的东西，发现很多不严谨的用法。为了能纠正自己的不良习惯，索性在这里总结一下容易出错的一些地方，希望以后能够逐步改进。

这里主要不是说明各种标点符号的用法，而是在电脑输入、排版时的一些问题。

# 英文

英文标点符号的用法可以参看 [Wikipedia][wiki_punctuation_en] 和《[The Elements of Style][style]》。

## 引号、撇号、上标符

首先容易浑淆的是「引号」及其面目相似的兄弟们：

符号 |Unicode |名称    |HTML
----|--------|--------|-----
'   |U+0027  |单直引号  |\&apos;
"   |U+0022  |双直引号  |\&quot;
‘  |U+2018  |单开弯引号|\&lsquo;
’  |U+2019  |单闭弯引号|\&rsquo;
“  |U+201C  |双开弯引号|\&ldquo;
”  |U+201D  |双闭弯引号|\&rdquo;
′  |U+2032  |上标符    |\&prime;
″  |U+2033  |双上标符  |\&Prime;

计算机键盘沿用了打字机的做法，将上述符号浓缩为两个：单直引号（'）和双直引号（"）。ASCII 码中也只收录了这两个字符，所以在早期的电子文档中大多是这两者身兼多职。这种引号通常叫做「Typewriter (“programmer’s”) straight quotes」——「打字机（程序员）直引号」：

>  "Good morning, Frank," said Hal.
>
> don't
>
> '06
>
> the cat's whiskers.
>
> 6' 2" tall.

为了更好的阅读体验，也有用[重音符（反引号）][wiki_grave]（`）来作为左引号的（如TeX）：

>  ``Good morning, Frank," said Hal.

随着 Unicode 的普及，计算机显示各种字符已经不成问题，让各个标点各司其职才能取得更好的阅读体验。上述标点符号应按照如下规则使用：

* 用弯引号「‘’」、「“”」作为单、双引号。

>
>  “Good morning, Frank,” said Hal.
>
>  ‘Good morning, Frank,’ said Hal.

* 撇号「’」用于缩写词、复数、所有格以及拼音分隔等。

> don’t
>
> ’06
>
> the cat’s whiskers.
>
> Xi’an

* 上标符「′」、「″」用于表示单位、数学公式等。

> 6′ 2″ tall.
>
> Tx = x′

* 直引号「'」，「"」只用于编程。

> char *s = "Hello world";
>
> char c = 'A';

## 连字号、连接号

另几个长得比较像的是连字号和连接号：

符号 |Unicode |名称        |HTML
-----|--------|-----------|---------
-    |U+002D  |连字暨减号 |
‐    |U+2010  |连字号     |
−    |U+2212  |减号       |\&minus;
‒    |U+2012  |数字线     |
–   |U+2013  |En dash    |\&ndash;
—   |U+2014  |Em dash    |\&mdash;

在 ASCII 中，「-」既当减号又当连字号，有时候几个组合起来作为连接号。在 UNICODE 中这几种符号都有了单独的字符。

* 连字号用于标志合成词或用于断字。

> ice‐cream‐flavored candy.
>
>  We, therefore, the represen‐
>
> tatives of the United States
>
> of America...

* 数字线用于连接数字（如电话号码中间的短线）。

> 0571‒87932195

* En dash 通常是 Em dash 的一半，它们的大小分别是大写字母 N 和 M 的宽度。En dash主要用于表示数值范围、对比的数值、相关的两件事或者合成词的属性部分。

> June–July 1967
>
> Australia beat American Samoa 31–0.
>
> Pre–Civil War era

* Em dash 表示语气转折，类似于中文的破折号。

Dash 的用法比较复杂，各种类似的符号及其用法可以参见 [Wikipedia][wiki_dash]。

# 中文

中文标点符号的使用参见 [Wikipedia][wiki_punctuation_zh]。

## 引号

中文的引号和英文的引号一样，都是用的弯引号，它们的 UNICODE 值也是一样的。这样导致一个问题：在文中出现引号时，是当成中文的全角呢还是英文的半角呢？因此使用[直角引号][zh_quote]「『』」的逐渐多了起来。

符号 |Unicode |名称        |HTML
-----|--------|------------|---------
「   |U+300C  |中式单开引号|
」   |U+300D  |中式单闭引号|
『   |U+300E  |中式双开引号|
』   |U+300F  |中式双闭引号|

## 中英文混排

有一种观点是混排时在中英文之间加上空格，在这方面还没有明确的规范。Adobe InDesign、Microsoft Word等软件在进行中英文混排时都会增大汉字与英文的间距，在这种情况下添加空格就没有必要；然而，大多数情况下我们没有这样的专业排版软件支持，这种情况下要想达到较好的排版效果就需要在汉字和西文之间加上半角的空格。[刘昕@知乎][zh_liuxi]认为：

> 中文正文及标题中出现的英文及数字应该使用半角方式输入，并且在左右各留一个半角空格。如果这些这些半角英文及数字的左边或者右边紧接着任何的中文全角括号或者其他标点符号的话，则不需要加入半角空格。

而[梁海@知乎][zh_lianghai]认为中英文混排中使用什么样的标点符号取决于「环境」：

> 事实上我自己考虑排版的时候从来不从“什么夹杂什么”的角度来看问题，我的思路永远是“环境”。就是说，在我写一段文字的时候，我会有自己的意识，意识到这段文字本质上是什么语言环境，然后以此为基础。而且基本环境中也会有子环境，比如一本中文译文的全部脚注或者某一条脚注或者正文中的一大段引文完全可以是一个英文环境（但我在做这样排版的时候会尽量不让它成为一个英文子环境），然后在中文正文中的一大段英文引文中如果再出现括号内的中文解释，我会酌情使用英文括号。你那最后一句话在我看来仍旧是中文环境，中文的逗号和问号都暗示/表明了这一点，这句话还不够独立。

具体采用什么样的方案要看使用场景，如果能从技术上做到中英文的隔离那是最好的了。

# 输入

规范使用标点符号最大的障碍在于输入。大部分标点符号都是 UNICODE 的，键盘很难直接输入。根据应用场景的不同大致有以下一些方法：

* Microsoft Word、Open Office 等软件本身提供了一些自动输入的方法，可以根据语境选择正确的标点符号。
* 输入法一般会为标点输入提供一些便捷。特别要推荐「[中州韻][rime]」输入法，它不但跨平台，还提供了强大的配置方案。
* HTML 可以使用「[字符值引用][ncr]」。
* Windows 可以用下「[Alt code][alt]」。
* Mac 下可以在「Unicode Hex Input」键盘下用「Option + xxxx」输入，其中 xxxx 表示十六进制的 UNICODE 值。
* 其它的输入方法参见 [Wikipedia][unicode_input]。


[style]: http://book.douban.com/subject/3296585/
[unicode_punctuation]: http://unicode.org/charts/PDF/U2000.pdf
[wiki_punctuation_en]: http://en.wikipedia.org/wiki/Punctuation_in_English
[wiki_punctuation_zh]: http://zh.wikipedia.org/wiki/%E6%A0%87%E7%82%B9%E7%AC%A6%E5%8F%B7
[wiki_grave]: http://en.wikipedia.org/wiki/Grave_accent
[wiki_dash]: http://en.wikipedia.org/wiki/Dash
[zh_quote]: http://www.zhihu.com/topic/19691803
[zh_liuxi]: http://www.zhihu.com/question/19587406
[zh_lianghai]: http://www.zhihu.com/question/19695720
[rime]: http://code.google.com/p/rimeime/
[alt]: http://en.wikipedia.org/wiki/Alt_code
[ncr]: http://en.wikipedia.org/wiki/Numeric_character_reference
[unicode_input]: http://en.wikipedia.org/wiki/Unicode_input
