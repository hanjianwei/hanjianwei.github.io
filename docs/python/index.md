---
title: Python
layout: page
---

## Package

- [Upgrading all packages with pip](http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip)

    ``` bash
    pip freeze --local | cut -d = -f 1  | xargs pip install -U
    ```

- [Listing dependencies of a package](http://stackoverflow.com/questions/2875232/list-python-package-dependencies-without-loading-them)

    ``` bash
    sfood -fuq package.py | sfood-filter-stdlib | sfood-target-files
    ```
- Retrieving python module path

    ``` python
    import a_module
    print a_module.__file__

    # or
    import os
    path = os.path.dirname(a_module.__file__)
    ```

- Merge two dicts

    ``` python
    z = dict(x.items() + y.items())
    ```

- Change dict key

    ``` python
    dict[new_key] = dict[old_key]
    del dict[old_key]

    dict[new_key] = dict.pop(old_key) # if old_key is defined
    ```
