---
title: 备份Mac AppStore中安装的应用
tags: devops
---

在Mac中安装软件并不像Linux那么方便，它没有一个统一的软件管理器来处理大部分的情况。我同时用了[Homebrew](http://brew.sh/)、[Homebrew Cask](http://caskroom.io/)和Mac AppStore来安装不同的软件。前者主要用于安装命令行程序，而后两者用于安装GUI程序。有些软件在Cask和AppStore中都有，以前我都是倾向于使用Cask，主要是便于备份，重新安装时比较方便。但是，Cask也有它自己的缺点，比如软件升级做得不好。最近试着去备份AppStore中的程序，希望能够自动化AppStore中程序的安装。

备份程序主要用了系统的`mdfind`和`mdls`命令:

~~~ bash
mdfind "kMDItemAppStoreHasReceipt=1" | while read -r app; do
  echo "$app\n$(mdls -name kMDItemAppStoreAdamID -raw $app)"
done > Applications.txt
~~~

App的程序名及其ID会被写入到`Applications.txt`中。

恢复安装时，读入`Applications.txt`，逐个读入应用，并打开AppStore进行安装：

~~~ bash
while read -r app; do
  read -r appid

  if [[ -e "$app" ]]; then
    open -W "macappstore://itunes.apple.com/cn/app/id$appid"
  fi
done < "./Applications.txt"
~~~

也算一种半人肉的安装方式吧。
