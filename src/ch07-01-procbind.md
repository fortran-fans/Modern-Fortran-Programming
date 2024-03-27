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
- `pass`关键字用来指定在调用的过程中，被调用的类型会**自动传递为第一个虚参**，与之对应的还有`nopass`
- `pass(this)`关键字也可以带具体的参数，用于指定哪个虚参充当被自动传递，当你的函数中有多个虚参都是当前类型的时候，你可以指定任意一个。
- 使用`=>`可以为绑定的过程重命名。
- 变量名尽量使用`this`或者`self`(与其他语言的习惯相符)

## 函数和运算符重载

函数中的接口非常复杂，有时候我们希望可以简化接口，这时候，使用重载是一个选择。例如对于`vector`类型，我们希望它也可以通过传入一个数组来初始化。使用`generic`关键字就可以
对函数进行重载

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
        implicit none
        class(frac),intent(in)::this
        type(frac)           ::z
        ! do something
    end function cancelling

    elemental function add(this,y)result(z)
        implicit none
        class(frac),intent(in)::this,y
        type(frac)           ::z
        z%num=this%num*y%den+y%num*this%den
        z%den=this%den*y%den
    end function add

    elemental function add_frac_num(this,m)result(z)
        implicit none
        class(frac),intent(in)::this
        integer,intent(in)    ::m
        type(frac)           ::z
        z%num=this%num+this%den * m
        z%den=this%den
    end function add_frac_num

    elemental function add_num_frac(m,this)result(z)
        implicit none
        class(frac),intent(in)::this
        integer,intent(in)    ::m
        type(frac)           ::z
        z%num=this%num+this%den * m
        z%den=this%den
    end function add_num_frac
end module frac_mod

program main
  use frac_mod
  implicit none
  type(frac)::x,y,z
  x=frac(1,2)
  y=frac(2,3)
  z=x+y
  write(*,*)z
  z=x+1
  write(*,*)z
  z=2+y
  write(*,*)z
end program main
```
## 习题
- 请你尝试补充完所有的运算符
- 尝试加入`gcd`对分数进行约分，补充`.reduce.`函数
