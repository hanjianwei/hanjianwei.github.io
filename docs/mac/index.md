---
title: Mac OS X tips
layout: page
---

## System

- 清除右键菜单重复项
``` bash
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user
```
