# 字符串数组

## 字符串切片

Fortran中的字符串也支持切片操作，但是相对于数组切片要弱一些，例如，取字符串的第i个字符需要使用`str(i:i)`，**不能反向切片**，**不能间隔切片**等
``` fortran
program string
  implicit none
  character(11)::str
  str="hello world"
  write(*,*)str(:5)
  !write(*,*)str(5),str(1:11:2) ,str(11:1:-1) !以上均不符合语法规范
end program string
```
``` sh
$ fpm run
 hello
```

## 可分配字符串
在Fortran2003引入了可分配的字符串，使用起来更加灵活，可以显式的分配内存，也可以自动分配内存。

使用可分配字符串可以有效的避免字符串拼接之后尾部空格的问题
``` fortran
program allocatable_string
  implicit none

  character(:), allocatable :: first_name
  character(:), allocatable :: last_name
  character(:), allocatable :: full_name

  ! 显式分配内存
  allocate(character(4) :: first_name)
  first_name = 'John'

  ! 自动分配内存
  last_name = 'Smith'

  full_name = first_name//' '//last_name
  write(*,*)full_name
end program allocatable_string
```
``` sh
$ fpm run
 John Smith
```
## 字符串数组

在Fortran中，字符串数组中的数组长度**必须相同**，使用数组构造器时也必须相同

``` fortran
program string_array
  implicit none
  character(len=10), dimension(2) :: keys
  character(len=:) , allocatable  :: vals(:)    !可分配的字符串数组，定义的时候必须都是可分配的
  !character(len=4) , allocatable  :: vals(:)    !错误

  keys = [character(len=10) :: "apple", "tree"] !这样可以给定构造器中字符串的长度
  write(*,*)keys(1)(1:3)                        !字符串数支持这类链式语法

  allocate(character(len=4)::vals(4))           !显式分配内存
end program string_array
```
``` sh
$ fpm run
 app
```
