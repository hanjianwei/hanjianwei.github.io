---
layout: post
title: "ABI compatibility between C++11 and C++98"
date: 2013-01-27 21:38
tags:
- "C++"
---

[C++11][]出来已经好几年了, 对其中有些特性还是很感兴趣的, 比如Rvalue reference, lambda, alias templates, range-based for等, 正好最近在写C++的代码, 就准备尝试一下.

Mac OS X下面主要的编译器是Clang, 对于[C++11的支持][Clang-c++11]还是很不错的. 不过Clang默认是用的还是C++98的标准, 要支持C++11必须使用两个选项:

- `-std=c++11`: 使用C++11的标准进行编译.
- `-stdlib=libc++`: 使用libc++. libc++是重新实现的C++标准库, 对C++11有较好的支持. 如果不加该选项, Clang就会是用老的libstdc++, 如果你使用了C++11标准库中的内容就会出错.

<!-- more -->

看起来修改还是挺简单的, 然后就把这两项加到我的`CXXFLAGS`里面, 不幸的是跳出来一大堆link error...

原来我用了一些OpenCV之类的库, 而我的库都是通过Homebrew安装的. Homebrew在编译这些库的时候是用的是默认的libstdc++, 而libc++和libstdc++是[不兼容][compatibility]的, 所以出现了link error.

解决方法只能是重新编译OpenCV等库, 使用libc++. 但是这样同时也要保证OpenCV等依赖的那些库也是用libc++, 而依赖OpenCV等库的程序最好也是用libc++, 这工作量就有点太大了! (当然, 如果只用C++11的语法而不使用库还是可以的, 即只用`-std=c++11`.)

好吧, 还是暂时放弃吧, 等什么时候`-std=c++11 -stdlib=libc++`成为默认参数的时候再搞吧. GCC似乎也有这种[C++11和C++98库不兼容][gcc-compatibility]问题, 看来也不好搞:(


[C++11]: http://en.wikipedia.org/wiki/C%2B%2B11
[Clang-c++11]: http://clang.llvm.org/cxx_status.html
[compatibility]: https://github.com/mxcl/homebrew/issues/10938
[gcc-compatibility]: http://www.mentby.com/Group/gcc-discuss/c98c11-abi-compatibility-for-gcc-47.html
