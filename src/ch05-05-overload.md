# 过程和运算符重载

在实际的函数编写过程中，有时候需要涉及多重类型，不同维度的数组。我们通常希望提供更加简单一致的接口，方便调用，这时候就需要用到重载。

## 过程重载

使用`interface`就可以对相关的过程进行重载

Fortran 2018引入了`generic`关键字，也可以对函数进行重载，语法大大简化(`gfortran`不支持，`ifx,flang`支持)

``` fortran
! src/add_mod.f90
module add_mod
  implicit none
  interface add
    module procedure add_int
    module procedure add_real
  end interface
  ! Fortran 2018 与上面四句等价
  !generic::add=>add_int,add_real
contains
  elemental integer function add_int(a,b)result(c)
    integer,intent(in)::a,b
    c=a+b
  end function add_int
  elemental real function add_real(a,b)result(c)
    real,intent(in)::a,b
    c=a+b
  end function add_real
end module add_mod
! app/main.f90
program main
  use add_mod
  write(*,*)add(1,2)
  write(*,*)add(1.0,2.0)
  !write(*,*)add(1.0,2) !错误 报错的一般形式为 no specific function for the generic 'add' 
 
end program main
```
```
$ fpm run
           3
   3.00000000 
```
如果使用`generic`语法，则使用`fpm run --compiler ifort`

## 运算符重载

对内置的运算符进行重载，有时候可以提高代码的一致性。

``` fortran
module add_mod
  implicit none
  interface operator(+)
    module procedure add_str
  end interface
  ! Fortran 2018 与上面等价
  !generic::operator(+)=>add_str
contains
  function add_str(a,b)result(c)
      character(len=*),intent(in)::a
      character(len=*),intent(in)::b
      character(len=:),allocatable::c
      c=trim(a)//","//trim(b)
  end function add_str
end module add_mod

program main
  use add_mod
  write(*,*)'"',"hello   "+"world ",'"'
end program main
```
```sh
$ fpm run
 "hello,world"
```
- 运算符重载有时候会写出比较含糊的代码，建议要谨慎使用。
- 不可以对运算符二次重载，例如我们无法对整数的加法再进行重载

## 自定义运算符

除了内置的运算符之外，Fortran也支持自定义运算符，使用两个点`.`作为标记，例如我们之前接触的`.lt.,.ge.`等

``` fortran
module find_mod
  implicit none
  interface operator(.in.)
    module procedure find
  end interface
  ! Fortran 2018 与上面等价
  !generic::operator(.in.)=>find
contains
  logical function find(v,a)result(res)
      integer,intent(in)::v
      integer,intent(in)::a(:)

      integer::i
      res=.false.
      do i=1,size(a)
        if(a(i)==v)then
          res=.true.
          return
        end if
      end do
  end function  find
end module find_mod

program main
  use find_mod
  write(*,*) 1 .in. [1,2,3,4]
  write(*,*) 5 .in. [1,2,3,4]
end program main
```
``` sh
$ fpm run
 T
 F
```
- 重载的函数和运算符**不能用于**Fortran的回调函数中。Fortran目前也没有`lambda`表达式。
