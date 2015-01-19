---
title: "C++11 和 C++98 的 ABI 兼容性"
tags: cpp
---

[C++11][] 出来已经好几年了，对其中有些特性还是很感兴趣的，比如 rvalue reference、lambda、alias templates、range-based for 等，正好最近在写 C++ 的代码，就准备尝试一下。

Mac OS X 下面主要的编译器是 Clang，对于 [C++11 的支持][Clang-c++11]还是很不错的。 不过 Clang 默认是用的还是 C++98 的标准，要支持 C++11 必须使用两个选项：

- `-std=c++11`: 使用 C++11 的标准进行编译。
- `-stdlib=libc++`: 使用 libc++。libc++ 是重新实现的 C++ 标准库，对 C++11 有较好的支持。 如果不加该选项，Clang 就会是用老的 libstdc++，如果你使用了 C++11 标准库中的内容就会出错。

看起来修改还是挺简单的，然后就把这两项加到我的 `CXXFLAGS` 里面，不幸的是跳出来一大堆 link error ……

原来我用了一些 OpenCV 之类的库，而我的库都是通过 Homebrew 安装的。Homebrew 在编译这些库的时候是用的是默认的 libstdc++，而 libc++ 和 libstdc++ 是[不兼容][compatibility]的，所以出现了 link error。

解决方法只能是重新编译 OpenCV 等库，使用 libc++。 但是这样同时也要保证 OpenCV 等依赖的那些库也是用 libc++，而依赖 OpenCV 等库的程序最好也是用 libc++，这工作量就有点太大了！——当然，如果只用 C++11 的语法而不使用库还是可以的，即只用 `-std=c++11`。

好吧，还是暂时放弃吧，等什么时候 `-std=c++11 -stdlib=libc++` 成为默认参数的时候再搞吧。 GCC似乎也有这种 [C++11 和 C++98 库不兼容][gcc-compatibility]问题，看来也不好搞:(


[C++11]: http://en.wikipedia.org/wiki/C%2B%2B11
[Clang-c++11]: http://clang.llvm.org/cxx_status.html
[compatibility]: https://github.com/mxcl/homebrew/issues/10938
[gcc-compatibility]: https://gcc.gnu.org/wiki/Cxx11AbiCompatibility
