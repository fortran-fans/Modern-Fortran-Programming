# 变量的定义
本节介绍Fortran中的变量定义，介绍内置的数据类型。

## Fortran变量的规则

Fortran中的变量定义分为了两个部分，前者是数据类型，后者是数据的属性，一个变量只能有一个类型，但是可以有多个属性。

## 基本的数据类型

Fortran中的基本数据类型有5种，每一种还具有不同的kind值，用来表示不同的精度。

| 类型名                 | 含义     | kind    | 默认kind |
| :-:                    | :-:      | :-:     | :-:      |
| `integer`              | 整数     | 1,2,4,8 | 4        |
| `real`                 | 小数     | 4,8,16  | 4        |
| `complex`              | 复数     | 4,8,16  | 4        |
| `character(len=[num])` | 字符串   | 1,4     | 1        |
| `logical`              | 逻辑类型 | 1,2,4,8 | 4        |

- `real`类型在编程中通常称为浮点数，而其对应的kind=4，8，16称为单精度，双精度，四精度浮点数。
- `integer`类型在编程中称为整型，而其对应的kind=4，8称为整型，长整型。

## 变量命名规则

Fortran中的可用于变量命名的字符包括数字，下划线，英文字母且不区分大小写。合法的变量名必须以英文字母开始。类型和变量名之间用`::`分隔，具有相同类型的变量可以写在同一行并用逗号隔开。

给出一个简单的定义变量的例子
``` fortran
program main
   implicit none
   real::a,sqrt_2
   integer::i,number_of_particles
   complex::c
   character(len=10)::str
   logical::flag
end program main
```

- 此处的`implicit none`表示变量未经定义不得使用，在程序中，应当**总是使用**该语句

这些定义使用的都是默认精度，如果想使用更高的精度，可以在对应的类型后加括号，例如
``` fortran
program main
   implicit none
   real(8)::a
   integer(1)::i
   complex(16)::c16
   logical(2)::flag
end program main
```
## 字面值

Fortran中的字面值拥有的是**对应变量类型的默认精度**，比如1.0是一个单精度浮点数，如果需要定义更高精度的字面值，在其后加下划线，并标注出kind值，例如

``` fortran
"hello Fortran"                                     ! 字符串
+1.234_8,1.2345e10_8,-1.2345e10_8                   ! 双精度浮点数
4294967296_8,-1234_8                                ! 长整型
(1.0,2.0)                                           ! 单精度复数
.true.,.false.                                      ! 逻辑值
```
- 这是Fortran中的一个易错点，因为大部分的编程语言默认的精度都是双精度，所以在切换到Fortran的时候很容易遇到精度不足的问题。

## 变量赋值

Fortran中的变量赋值使用的是`=`，使用`write`输出

``` fortran
!文件名app/main.f90
program main
   implicit none
   integer::i
   real::pi
   character(len=8)::str
   i=42
   pi=3.14159
   str="Fortran"
   write(*,*)i,pi,str
end program main
```

运行结果

``` sh
$ fpm run
Project is up to date
          42   3.14159012     Fortran
```

- 你可能已经发现输出的浮点数似乎和你设置的值总是不太符合。这和浮点数的精度有关，具体见下一节。

## 常量属性

在实际的编程中，有些数是不会变的，比如圆周率pi,重力加速度g，这时候就可以将其定义为常量。常量使用`parameter`来标记，是我们学习到的第一个属性。

``` fortran
!文件名app/main.f90
program main
   implicit none
   real,parameter::pi=3.1415926
   real,parameter::g=9.8
   write(*,*)pi,g
end program main
```
运行结果

``` sh
$ fpm run
Project is up to date
   3.14159250       9.80000019
```
常量是不可修改的。

同时，我们也可以使用常量来为字面量设置精度
``` fortran
program main
   implicit none
   integer,parameter::sp=4
   real(sp)::a
   a=1.234_sp
   write(*,*)a
end program main
```
``` sh
$ fpm run
Project is up to date
   1.23399997
```
## block语句

Fortran2008之前，变量的定义必须在程序的开头完成，Fortran2008引入了`block`语句，这样我们就可以在程序任意位置定义变量
``` fortran
program main
    implicit none
    real :: x

    block
        real :: y ! 局部变量
        y = 2.0
        x = y ** 2
        write(*,*) y
    end block
    ! write(*,*) y !y出了作用域，已经不存在了
    write(*,*) x   ! 输出 4.00000000
end program main
```
``` sh
$ fpm run
Project is up to date
   2.00000000
   4.00000000
```
如果你取消注释，则会显式
``` sh
$ fpm run
[ 66%] Compiling...
app/main.f90:11:16:

   11 |     write(*,*) y !y出了作用域，已经不存在了
      |                1
Error: Symbol 'y' at (1) has no IMPLICIT type
```
## 注意事项

- Fortran中的变量只能在程序块的开头定义，执行语句（比如赋值语句）不能出现在变量定义的部分。
- Fortran的赋值可以在变量定义时使用，比如`real::a=123.4`,出于一些特别的原因，本教程不使用这种语法。
- 在书写程序的时候，尽量使用有意义的变量名，并搭配合理的注释，使得程序更加清晰明了。

## 思考题
- 如果变量不定义直接输出，会出现什么问题？
- 如果把一个双精度浮点数的字面值赋值给单精度浮点数变量，会输出什么？
- 对一个带有`parameter`属性的量进行修改，会发生什么事情？
