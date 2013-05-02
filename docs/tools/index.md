---
title: Tools
layout: page
---

## Encoding

- Conversion

    ``` bash
    iconv -f GBK -t UTF-8 file_gbk.txt > file_utf8.txt
    ```

## Mac

- Remove multiple items in 'open with' menu:

    ``` bash
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user
    ```

## Vim

- Format json

    ``` bash
    :%!python -m json.tool
    ```

- Input control sequence <kbd>CTRL</kbd>-<kbd>V</kbd>, <kbd>CTRL</kbd>-<kbd>M</kbd>
