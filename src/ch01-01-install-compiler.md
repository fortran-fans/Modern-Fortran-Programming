# 安装Fortran开发环境

本教程使用Msys2-GFortran编译器进行Fortran开发，它的优点有：
- 可以生成Windows本地化执行程序；
- 国人更熟悉Windows环境；
- 方便管理和升级；
- 性能很好。

缺点有：
- 运行时更详细的堆栈错误信息缺失；
- 调试不算方便；
- 可能存在配套工具Windows环境不适应的问题。

即使它有如上缺点，但它仍是一款很强的Fortran编译器，且随着用户的使用和MSYS2的进步，它也会越来越好用。

## 安装MSYS2-GFortran软件

前往MSYS2官网下载安装MSYS2安装包，并阅读相关文档。

这里列出一些有用的部分命令：
```sh
pacman -Syu                  # 升级msys2内部组件和仓库信息
pacman -Ss <package_name>    # 搜索软件
pacman -S  <package_name>    # 安装软件
pacman -Qs <package_name>    # 查询本地安装的特定软件
pacman -Rs <package_name>    # 卸载软件
pacman -R --help             # 查询命令的帮助文档
...
```

我们可以通过以下命令安装MSYS2-GFortran：
```sh
pacman -Ss fortran           # 查询名字中含“Fortran”字符的包
pacman -S  ucrt64/mingw-w64-ucrt-x86_64-gcc-fortran    # 安装ucrt64版本的gfortran
```

为了方便我们在MSYS2环境之外使用MSYS2-GFortran，我们需要设置如下环境变量：
```sh
C:/msys64/ucrt64/bin         # UCRT64环境的二进制可执行程序所在路径
C:/msys64/usr/bin            # MSYS2 环境的二进制可执行程序所在路径
```

我们可以在Windows下的CMD中使用以下命令核对环境变量是否设置正确：
```sh
$ gfortran
GNU Fortran (Rev2, Built by MSYS2 project) 11.2.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

> 🔰 提示：这里默认我们现在大多数使用的硬件是64位的，且使用较新的MSYS2环境（UCRT），有个性化需求可以进行自定义。