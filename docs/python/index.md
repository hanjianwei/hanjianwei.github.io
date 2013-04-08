---
title: Python
layout: page
---

## Package

* [Upgrading all packages with pip](http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip)

``` bash
pip freeze --local | cut -d = -f 1  | xargs pip install -U
```

* [Listing dependencies of a package](http://stackoverflow.com/questions/2875232/list-python-package-dependencies-without-loading-them)

``` bash
sfood -fuq package.py | sfood-filter-stdlib | sfood-target-files
```
* Retrieving python module path

``` python
import a_module
print a_module.__file__

# or
import os
path = os.path.dirname(amodule.__file__)
```
