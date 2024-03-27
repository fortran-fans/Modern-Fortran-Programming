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

