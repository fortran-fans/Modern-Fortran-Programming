# 过程指针

指针也可以指向过程，这时候需要先声明指针的接口，用于限制指针的类型，也就是在之前的章节中我们提到的`abstract interface`

``` fortran
module proc_pointer_mod
    implicit none
    abstract interface
        real(8) function func1d(x) result(res)
            real(8),intent(in)::x
        end function func1d
    end interface
contains
    real(8) function mysin(x) result(res)
        real(8),intent(in)::x
        res=sin(x)
    end function mysin
    real(8) function myexp(x) result(res)
        real(8),intent(in)::x
        res=exp(x)
    end function myexp
    real(8) function mycos(x) result(res)
        real(8),intent(in)::x
        res=cos(x)
    end function mycos
end module proc_pointer_mod

program main
    use proc_pointer_mod
    implicit none
    procedure(func1d),pointer::ptr=>null()
    ptr=>mysin
    write(*,*)ptr(1.0_8)
    ptr=>myexp
    write(*,*)ptr(1.0_8)
    ptr=>mycos
    write(*,*)ptr(1.0_8)
end program main
```
- 不能使用过程指针指向通用函数名。由于Fortran的内置函数都是经过重载的通用函数，所以也不能用过程指针指向内置函数

如果定义一个过程指针数组，则需要使用到自定义类型，同时也要指定`nopass`关键字，用来表示不需要绑定该类型作为第一个虚参传递。
``` fortran
module proc_pointer_mod
    implicit none
    abstract interface
        real(8) function func1d(x) result(res)
            real(8),intent(in)::x
        end function func1d
    end interface
    type ptrfunc
        procedure(func1d),pointer,nopass::ptr
    end type ptrfunc
contains
    real(8) function mysin(x) result(res)
        real(8),intent(in)::x
        res=sin(x)
    end function mysin
    real(8) function myexp(x) result(res)
        real(8),intent(in)::x
        res=exp(x)
    end function myexp
    real(8) function mycos(x) result(res)
        real(8),intent(in)::x
        res=cos(x)
    end function mycos
end module proc_pointer_mod

program main
    use proc_pointer_mod
    implicit none
    type(ptrfunc)::a(3)
    integer::i
    a(1)%ptr=>mysin
    a(2)%ptr=>myexp
    a(3)%ptr=>mycos
    write(*,*)(a(i)%ptr(1.0_8),i=1,3) !此处使用隐式循环输出
end program main
```

- 使用过程指针后，一些操作需要转向运行时确定，所以编译器无法进行更加激进的优化(内联inline)，代码的运行速度有可能会降低。
  
## 习题
- 思考为什么不使用`procedure(func1d),pointer::ptr(:)`来定义过程指针数组



