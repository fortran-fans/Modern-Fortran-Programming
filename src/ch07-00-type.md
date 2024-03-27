# 派生类型(自定义类型)

当我们需要将一些基础类型组合起来使用，例如定义一个粒子，考虑它的质量，速度，位置等各种信息，如果单独声明变量则代码会显得冗余，此时就可以使用自定义类型

## 类型的定义

Fortran中使用`type`关键字来定义派生类型 (其他语言中叫做结构体或者类)

``` fortran
type :: particle_t
  real :: mass , v (3) ,x(3) !质量，速度，位置
end type particle_t
```
派生类型同时还可以作为其他派生类型的成员，我们可以将其自由组合，构造出适合我们当前问题的类型。
``` fortran
type :: electron_t
  type(particle_t)::p
  integer :: charge  !添加电荷属性
end type electron_t
```
- 自定义的类型一般定义在`module`中
- 包含的元素我们称为**成员**

同时，一个类型也可以由另一个类型扩展而来

``` fortran
type, extends(particle_t) :: electron_t
  real :: spin  !添加自旋属性
end type electron_t
```
此时结构体`electron_t`中包含了成员`mass,v,x`,也包含了 `spin`

## 派生类型成员的访问和初始化

使用`%`可以对成员进行访问。每个派生类型都有一个内置的构造函数，可以直接进行初始化

``` fortran
module particle_mod
  implicit none
  type :: particle_t
    real :: mass , v (3) ,x(3)
  end type particle_t
end module particle_mod

program main
  use particle_mod
  implicit none
  type(particle_t)::p
  type(particle_t)::parray(100)!也可以定义为数组
  type(particle_t),allocatable::palloc(:)!也可以定义为可分配数组
  p%mass=1.0 !使用%进行访问并初始化
  p=particle_t(1.0,[1.0,-2.0,3.0],[1.0,1.0,2.0]) !使用构造函数初始化
  p=particle_t(v=[1.0,-2.0,3.0],x=[1.0,1.0,2.0],mass=1.0) !也可以使用关键字参数
end program main
```




