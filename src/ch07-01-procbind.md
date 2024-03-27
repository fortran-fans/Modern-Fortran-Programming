# 过程绑定

Fortran2003开始支持过程绑定，将子程序或者函数与对应的类型相关联，使用的方法和访问成员类似。这样的做法可以提高代码的一致性。

## 过程绑定的语法

过程绑定中， 对应子过程的虚参声明需要使用`class`关键字。同时在类型的定义中使用`procedure`关键字将其绑定,使用`contains`将类型和函数分开。

``` fortran
module vector_mod
  implicit none
  type vector_t
    real,allocatable::x(:)
  contains
    procedure,pass:: init => vector_init
  end type vector_t
contains
  subroutine vector_init(this,n)
    class(vector_t),intent(inout)::this
    integer,intent(in)::n
    allocate(this%x(n))
  end subroutine vector_init
end module vector_mod

program main
  use vector_mod
  implicit none
  type(vector_t)::v
  call v%init(10)
end program main

```
- `pass`关键字用来指定在调用的过程中，被调用的类型会**自动传递为第一个虚参**，与之对应的还有`nopass`，不自动传递
- `pass(this)`关键字也可以带具体的参数，用于指定哪个虚参被自动传递。当你的函数中有多个虚参都是当前类型的时候，你可以指定任意一个。
- 使用`=>`可以为绑定的过程重命名。
- 被绑定的变量名尽量使用`this`或者`self`(与其他语言的习惯相符)

## 函数重载

当定义的函数很多的时候，函数名会非常复杂，有时候我们希望可以简化，这时候，使用重载是一个选择。例如对于`vector`类型，我们希望它也可以通过传入一个数组来初始化。使用`generic`关键字就可以对函数进行重载

``` fortran
module vector_mod
  implicit none
  type vector_t
    real,allocatable::x(:)
  contains
    generic::init=>vector_init,vector_init_array
    procedure,pass:: vector_init,vector_init_array
  end type vector_t
contains
  subroutine vector_init(this,n)
    class(vector_t),intent(inout)::this
    integer,intent(in)::n
    allocate(this%x(n))
  end subroutine vector_init

  subroutine vector_init_array(this,a)
    class(vector_t),intent(inout)::this
    real,intent(in)::a(:)
    allocate(this%x,source=a)
  end subroutine vector_init_array
end module vector_mod

program main
  use vector_mod
  implicit none
  type(vector_t)::v
  type(vector_t)::va
  call v%init(10)
  call va%init([real::1,2,3,4])
end program main
```
此时使用两种方式均可以对其进行初始化。

## 运算符重载

有时候，我们也希望对内置的运算符进行重载，用来提高代码的一致性。例如我们有一个分数类型，它有`+-*/`和`**`的操作，但是如果使用过程绑定的函数则显得代码过于臃肿。此时就可以使用运算符重载

``` fortran
module frac_mod
    implicit none
    type frac
        integer(8)::num!numerator
        integer(8)::den!denominator
    contains
        generic::operator(.reduce.)=>cancelling !也可以使用自定义运算符
        generic::operator(+)=>add,add_frac_num,add_num_frac
        !generic::operator(-)=>sub
        !generic::operator(*)=>mult
        !generic::operator(/)=>div
        !generic::operator(**)=>pow
        !
        procedure,pass      ::add,add_frac_num
        procedure,pass(this)::add_num_frac
        procedure,pass      ::cancelling
        !procedure,pass::sub
        !procedure,pass::mult
        !procedure,pass::divi
    end type
contains
    elemental function cancelling(this)result(z)
        class(frac),intent(in)::this
        type(frac)           ::z
        ! do something
    end function cancelling

    type(frac) elemental function add(this,y)result(z)
        class(frac),intent(in)::this,y
        z%num=this%num*y%den+y%num*this%den
        z%den=this%den*y%den
    end function add

    type(frac) elemental function add_frac_num(this,m)result(z)
        class(frac),intent(in)::this
        integer,intent(in)    ::m
        z%num=this%num+this%den * m
        z%den=this%den
    end function add_frac_num

    type(frac) elemental function add_num_frac(m,this)result(z)
        class(frac),intent(in)::this
        integer,intent(in)    ::m
        z%num=this%num+this%den * m
        z%den=this%den
    end function add_num_frac
end module frac_mod

program main
  use frac_mod
  implicit none
  type(frac)::x,y,z,w(2)
  x=frac(1,2)
  y=frac(2,3)
  w=[frac(1,4),frac(1,3)] !自定义类型数组初始化
  z=x+y
  write(*,*)z
  z=x+1
  write(*,*)z
  z=2+y
  write(*,*)z
  write(*,*)w+2 !也支持数组
end program main
```
- 除此之外，也可以对比较运算符进行重载，注意比较运算符中运算符和其对应的旧形式属于同一个函数，不能重载为不同的功能。

## 赋值运算符的重载

赋值的运算符具有特有的形式`assignment(=)`

``` fortran
module string_mod
  implicit none
  type string
    character(:),allocatable::str
  contains
    generic::assignment(=)=>equal
    procedure,pass::equal
  end type string
contains
  subroutine equal(this,s)
    class(string),intent(inout)::this
    character(len=*),intent(in)::s
    this%str=s
  end subroutine equal
end module string_mod

program main
  use string_mod
  implicit none
  type(string)::s
  s="123"
  !内置构造函数形式 
  s=string("456")
end program main 
```

## 习题
- 请你尝试补充完所有的运算符
- 尝试加入`gcd`对分数进行约分，补充`.reduce.`函数
- (附加题)完成分数类，并使用高斯消元法求解希尔伯特矩阵的行列式和逆矩阵

