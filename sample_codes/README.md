# 现代Fortran程序设计的随书代码

## 代码风格
一般情况下，本书中的Fortran代码将遵守如下代码风格。

* 对module中的变量与过程通过`private`/`public`对可见性进行限定。
```fortran
module m
    implicit none
    private
    public :: a, x

    integer, parameter :: a = 1
    integer, dimension(:), allocatable :: x
    real :: b ! b is private

end module
```
* 用`use`导入module时严格用`only`限定导入内容。
```fortran
use m, only: a
```
* 用`dimension`属性定义数组。
* 定义变量时显式写出`len`/`kind`。
* 命名使用小写字母和下划线。
* 缩进为四个空格。
